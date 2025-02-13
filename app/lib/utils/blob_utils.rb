module BlobUtils
  class << self
    def compute_checksum(base64_data)
      Digest::MD5.hexdigest(decode_base64(base64_data).string)
    end
    def decode_base64(base64_data)
      # Remove data URL prefix if present
      base64_string = base64_data.sub(/\Adata:.+;base64,/, "")
      decoded_data = Base64.strict_decode64(base64_string)
      StringIO.new(decoded_data)
    rescue ArgumentError => e
      raise Error, "Invalid base64 data: #{e.message}"
    end
  end
end
