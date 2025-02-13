require "net/http"
require "openssl"
require "base64"
require "time"

module Storage
  class S3Adapter < BaseAdapter
    def initialize(endpoint:, bucket:, access_key:, secret_key:, region: "us-east-1")
      @endpoint = URI(endpoint)
      @bucket = bucket
      @access_key = access_key
      @secret_key = secret_key
      @region = region
    end

    def upload(key, io, filename:, content_type: nil, **options)
      date = Time.now.utc.httpdate
      content_type ||= "application/octet-stream"

      url = object_url(key)
      request = Net::HTTP::Put.new(url)
      request.body = io.read
      request["Host"] = url.host
      request["Date"] = date
      request["Content-Type"] = content_type

      sign_request(request, date)

      response = make_request(request)
      response.is_a?(Net::HTTPSuccess)
    end

    def download(key)
      date = Time.now.utc.httpdate
      url = object_url(key)
      request = Net::HTTP::Get.new(url)
      request["Host"] = url.host
      request["Date"] = date

      sign_request(request, date)

      response = make_request(request)
      return nil unless response.is_a?(Net::HTTPSuccess)

      StringIO.new(response.body)
    end

    private

    def object_url(key)
      URI("#{@endpoint}/#{@bucket}/#{key}")
    end

    def make_request(request)
      Net::HTTP.start(request.uri.host, request.uri.port, use_ssl: request.uri.scheme == "https") do |http|
        http.request(request)
      end
    end

    def sign_request(request, date)
      string_to_sign = [
        request.method,
        "",
        request["Content-Type"] || "",
        date,
        "/#{@bucket}#{request.path}"
      ].join("\n")

      signature = Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new("sha1"),
          @secret_key,
          string_to_sign
        )
      ).strip

      request["Authorization"] = "AWS #{@access_key}:#{signature}"
    end
  end
end
