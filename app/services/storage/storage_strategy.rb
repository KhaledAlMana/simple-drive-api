require "base64"

class StorageStrategy
  class Error < StandardError; end
  def initialize
    @adapter = StorageType.adapter_for(StorageType.get_selected_storage_type).new
  end

  def upload(base64_data:, blob_id:, **options)
    ::BlobUtils.decode_base64(base64_data)
    if @adapter.upload(base64_data: base64_data, blob_id: blob_id)
      true
    else
      raise Error, "Failed to upload file"
    end
  end

  def download(blob_id:, storage_type:)
    adapter = StorageType.adapter_for(storage_type).new
    adapter.download(blob_id: blob_id)
  rescue StandardError => e
    Rails.logger.error "Download failed: #{e.message}, blob_id: #{blob_id}"
    raise Error, "Failed to download file: #{e.message}"
  end
end
