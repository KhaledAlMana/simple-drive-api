module Storage
  class DatabaseAdapter < BaseAdapter
    def initialize
    end
    def upload(base64_data:, blob_id:, **options)
      DbStorage.create!(
        blob_id: blob_id,
        data: base64_data
      )
    end

    def download(blob_id:)
      storage = DbStorage.find_by(blob_id: blob_id)
      raise BlobNotFoundError, "Storage record not found for blob_id: #{blob_id}" unless storage
      storage.data
    rescue StandardError => e
      Rails.logger.error "DatabaseAdapter#download failed: #{e.message}, blob_id: #{blob_id}"
      raise StorageError, "Failed to download file: #{e.message}"
    end

    def exists?(blob_id:)
      DbStorage.exists?(blob_id: blob_id)
    end
  end
end
