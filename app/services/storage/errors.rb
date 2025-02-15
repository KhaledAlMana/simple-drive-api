module Storage
  class StorageError < StandardError; end
  class BlobNotFoundError < StorageError; end
  class InvalidDataError < StorageError; end
end
