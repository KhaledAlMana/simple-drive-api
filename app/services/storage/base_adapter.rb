module Storage
  class BaseAdapter
    def upload(base64_data, blob_id:, **options)
      raise NotImplementedError
    end

    def download(blob_id)
      raise NotImplementedError
    end

    def exists?(blob_id)
      raise NotImplementedError
    end
  end
end
