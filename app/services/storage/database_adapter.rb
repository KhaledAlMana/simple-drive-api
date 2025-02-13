module Storage
  class DatabaseAdapter < BaseAdapter
    def initialize
    end
    def upload(base64_data, blob_id:, **options)
      DbStorage.create!(
        blob_id: blob.id,
        data: base64_data
      )
    end

    def download(blob_id)
      storage = DbStorage.find_by(blob_id: blob_id)
      storage.data
    end

    def exists?(blob_id)
      DbStorage.exists?(blob_id: blob_id)
    end
  end
end
