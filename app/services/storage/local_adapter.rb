require "fileutils"

module Storage
  class LocalAdapter < BaseAdapter
    DEFAULT_STORAGE_ROOT = ENV.fetch("STORAGE_LOCAL_PATH", Rails.root.join("storage/local").freeze)

    def initialize(config = {})
      @root_path = Pathname.new(DEFAULT_STORAGE_ROOT)
      @root_path.mkpath unless @root_path.directory?
    end

    def upload(base64_data, blob_id:, **options)
      filename = generate_filename(blob_id)
      full_path = @root_path.join(filename)

      begin
        blob = ::BlobUtils.decode_base64(base64_data)
        FileUtils.mkdir_p(full_path.dirname)
        # Create storage record first to ensure atomicity
        storage = LocalStorage.create!(
          blob_id: blob.id,
          full_path: full_path.to_s
        )

        # Write file after storage record is created
        write_file(blob, full_path)

        storage
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "LocalAdapter#upload failed (RecordInvalid): #{e.message}, blob_id: #{blob_id}"
        raise StorageError, "Failed to upload file: #{e.message}"
      rescue StandardError => e
        Rails.logger.error "LocalAdapter#upload failed: #{e.message}, blob_id: #{blob_id}"
        # Cleanup any created files if storage record failed
        File.delete(full_path.to_s) if File.exist?(full_path.to_s)
        raise StorageError, "Failed to upload file: #{e.message}"
      end
    end

    def download(blob_id, **)
      storage = find_storage(blob_id)
      File.open(storage.full_path, "rb")
    rescue Errno::ENOENT => e
      Rails.logger.error "LocalAdapter#download failed: #{e.message}, blob_id: #{blob_id}"
      raise BlobNotFoundError, "File not found at #{storage.full_path}"
    end

    def exists?(blob_id)
      storage = LocalStorage.find_by(blob_id: blob.id)
      storage.present? && File.exist?(storage.full_path)
    end

    private
    def find_storage(blob_id)
      LocalStorage.find_by!(blob_id: blob_id)
    end

    def generate_filename(blob_id)
      "#{blob_id}_#{Time.current.strftime('%Y%m%d%H%M%S')}"
    end

    def write_file(io, path)
      File.open(path, "wb") do |file|
        if io.respond_to?(:read)
          IO.copy_stream(io, file)
        else
          file.write(io)
        end
      end
    end
  end
end
