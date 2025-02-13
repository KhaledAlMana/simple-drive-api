module StorageType
  STORAGE_TYPE = ENV.fetch("STORAGE_TYPE", :local).to_sym

  TYPES = {
    local: 0,
    s3: 1,
    db: 2,
    ftp: 3
  }.freeze

  module_function

  def types
    TYPES
  end

  def valid?(storage)
    TYPES.key?(storage.to_sym)
  end

  def getSelectedStorageType
    STORAGE_TYPE
  end

  def adapter_for(storage)
    case storage.to_sym
    when :local then Storage::LocalAdapter
    when :s3 then Storage::S3Adapter
    when :db then Storage::DatabaseAdapter
    when :ftp then Storage::FTPAdapter
    else
      Storage::LocalAdapter # Default to local storage
    end
  end
end
