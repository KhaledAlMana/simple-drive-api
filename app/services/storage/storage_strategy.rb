require "base64"

class StorageStrategy
  class Error < StandardError; end
  def initialize
    @adapter = StorageType.adapter_for(StorageType.getSelectedStorageType)
      case StorageType.getSelectedStorageType
      when :s3
        @adapter = adapter.new(
          endpoint: ENV["S3_ENDPOINT"],
          bucket: ENV["S3_BUCKET"],
          access_key: ENV["S3_ACCESS_KEY"],
          secret_key: ENV["S3_SECRET_KEY"]
        )
      when :db
        @adapter = adapter_class.new()
      when :ftp
      when :local # Since local is the default, we don't need to specify the root
      else
        @adapter = adapter_class.new()
      end
  end

  # Upload a file to the storage service. Returns the blob id if successful, otherwise raises an error.
  def upload(base64_data, blob_id,  **options)
    ::BlobUtils.decode_base64(base64_data)
    if blob_type_id = @adapter.upload(base64_data blob_id, *options)
      blob_type_id
    else
      raise Error, "Failed to upload file"
    end
  end

  def download(key)
    @adapter.download(key)
  end
end
