require "net/http"
require "openssl"
require "base64"
require "time"
require "securerandom"
require_relative "errors"
# Supports AWS S3 V4 signature version only.
module Storage
  class S3Adapter < BaseAdapter
    def initialize
      unless ENV["STORAGE_S3_ENDPOINT"] && ENV["STORAGE_S3_BUCKET"] && ENV["STORAGE_S3_ACCESS_KEY"] && ENV["STORAGE_S3_SECRET_KEY"] && ENV["STORAGE_S3_REGION"]
        raise ArgumentError, "Missing required environment variables: STORAGE_S3_ENDPOINT, STORAGE_S3_BUCKET, STORAGE_S3_ACCESS_KEY, STORAGE_S3_SECRET_KEY, STORAGE_S3_REGION"
      end

      @endpoint = URI(ENV["STORAGE_S3_ENDPOINT"])
      @bucket = ENV["STORAGE_S3_BUCKET"]
      @access_key = ENV["STORAGE_S3_ACCESS_KEY"]
      @secret_key = ENV["STORAGE_S3_SECRET_KEY"]
      @region = ENV["STORAGE_S3_REGION"]
      @force_path_style = ENV.fetch("STORAGE_S3_FORCE_PATH_STYLE", "false") == "true"
      @service_name = ENV.fetch("STORAGE_S3_SERVICE_NAME", "s3")

      # Init HTTP client
      @http = Net::HTTP.new(@endpoint.host, @endpoint.port)
      @http.use_ssl = @endpoint.scheme == "https"
    end

    def upload(base64_data:, blob_id:, **_options)
      binary_data = ::BlobUtils.decode_base64(base64_data)
      key = blob_id

      request = prepare_request(
        method: :put,
        key: key,
        body: binary_data.string
      )

      begin
        storage = S3Storage.create!(
          blob_id: blob_id,
          bucket: @bucket,
          key: key,
          region: @region
        )

        response = @http.request(request)
        unless response.is_a?(Net::HTTPSuccess)
          storage.destroy
          Rails.logger.error "S3Adapter#upload failed: #{response.code} - #{response.message} - #{response.body}, blob_id: #{blob_id}"
          raise StorageError, "S3 upload failed"
        end

        storage
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "S3Adapter#upload failed (RecordInvalid): #{e.message}, blob_id: #{blob_id}"
        raise StorageError, "Failed to create storage record"
      rescue StandardError => e
        Rails.logger.error "S3Adapter#upload failed: #{e.message}, blob_id: #{blob_id}"
        storage&.destroy
        raise StorageError, "Failed to upload file"
      end
    end

    def download(blob_id:)
      storage = S3Storage.find_by(blob_id: blob_id)
      return nil unless storage

      request = prepare_request(method: :get, key: storage.key)
      response = @http.request(request)

      return nil unless response.is_a?(Net::HTTPSuccess)
      Base64.strict_encode64(response.body)
    end

    def exists?(blob_id:)
      storage = S3Storage.find_by(blob_id: blob_id)
      return false unless storage

      request = prepare_request(method: :head, key: storage.key)
      response = @http.request(request)

      response.is_a?(Net::HTTPSuccess)
    end

    private

    def prepare_request(method:, key:, body: nil)
      date = Time.now.utc
      url = object_url(key)
      request = case method
      when :put then Net::HTTP::Put.new(url)
      when :get then Net::HTTP::Get.new(url)
      when :head then Net::HTTP::Head.new(url)
      end

      # Calculate payload hash; Required for signing
      payload_hash = body ? OpenSSL::Digest::SHA256.hexdigest(body) : OpenSSL::Digest::SHA256.hexdigest("")

      # Add headers in canonical order (all lowercase for signing)
      if body
        request["content-length"] = body.bytesize.to_s
        request["content-type"] = "application/octet-stream"
      end
      request["host"] = url.host
      request["x-amz-content-sha256"] = payload_hash
      request["x-amz-date"] = date.strftime("%Y%m%dT%H%M%SZ")

      # Set body after headers
      request.body = body if body

      sign_request(request, date, payload_hash)
      request
    end

    def object_url(key)
      if @force_path_style
        path = "/#{@bucket}/blobs/#{key}"
      else
        path = "/blobs/#{key}"
      end

      Rails.logger.debug "Object URL Path: #{path}"

      uri = URI::HTTPS.build(
        host: @endpoint.host,
        port: @endpoint.port,
        path: path
      )

      Rails.logger.debug "Full URL: #{uri}"
      uri
    end

    def sign_request(request, datetime, payload_hash)
      datestamp = datetime.strftime("%Y%m%d") # YYYYMMDD

      # Calculate signing key
      k_date = OpenSSL::HMAC.digest("SHA256", "AWS4#{@secret_key}", datestamp)
      k_region = OpenSSL::HMAC.digest("SHA256", k_date, @region)
      k_service = OpenSSL::HMAC.digest("SHA256", k_region, @service_name)
      signing_key = OpenSSL::HMAC.digest("SHA256", k_service, "aws4_request")

      # Collect headers in canonical order
      headers_to_sign = {}
      headers_to_sign["content-length"] = request["Content-Length"] if request["Content-Length"]
      headers_to_sign["content-type"] = request["Content-Type"] if request["Content-Type"]
      headers_to_sign["host"] = request["Host"]
      headers_to_sign["x-amz-content-sha256"] = payload_hash
      headers_to_sign["x-amz-date"] = request["X-Amz-Date"]

      # Create canonical headers maintaining order
      canonical_headers = headers_to_sign.map { |k, v| "#{k}:#{v.to_s.strip}" }.join("\n")
      signed_headers = headers_to_sign.keys.join(";")

      # Create canonical request with normalized components
      canonical_request = [
        request.method,
        request.path,
        request.uri.query.to_s,
        canonical_headers + "\n",
        signed_headers,
        payload_hash
      ].join("\n")

      # Create string to sign
      credential_scope = "#{datestamp}/#{@region}/s3/aws4_request"
      string_to_sign = [
        "AWS4-HMAC-SHA256",
        datetime.strftime("%Y%m%dT%H%M%SZ"),
        credential_scope,
        OpenSSL::Digest::SHA256.hexdigest(canonical_request)
      ].join("\n")

      signature = OpenSSL::HMAC.hexdigest("SHA256", signing_key, string_to_sign)

      request["Authorization"] = [
        "AWS4-HMAC-SHA256 Credential=#{@access_key}/#{credential_scope}",
        "SignedHeaders=#{signed_headers}",
        "Signature=#{signature}"
      ].join(",")

      Rails.logger.debug "Canonical Request:\n#{canonical_request.inspect}" # Inspect for hidden chars
      Rails.logger.debug "String to Sign:\n#{string_to_sign.inspect}"       # Inspect for hidden chars
      Rails.logger.debug "Signature: #{signature.inspect}"            # Inspect for hidden chars
      Rails.logger.debug "Headers to Sign: #{headers_to_sign.inspect}"
      Rails.logger.debug "Signed Headers: #{signed_headers.inspect}"
      Rails.logger.debug "Authorization Header: #{request["Authorization"].inspect}"
    end
  end
end
