module Features
  module Blobs
    class Download
      def initialize(dto)
        @dto = dto
      end

      def call
        return @dto.errors unless @dto.valid?

        blob = find_blob
        data = download_blob_data(blob)
        APIResponse.json_response(
          GetBlobResponseDTO.new(
            id: blob.key,
            data: data,
            size: blob.byte_size,
            created_at: blob.created_at)
        )
      rescue ActiveRecord::RecordNotFound
        ::APIResponse.error_response("Blob not found", :not_found)
      rescue StandardError => e
        ::APIResponse.error_response(e.message, :unprocessable_entity)
      end

      private

      def find_blob
        BlobAggregate.find_by!(key: @dto.id) # Id here is the key of the blob
      end

      def download_blob_data(blob)
        ::StorageStrategy.new.download(blob_id: blob.id, storage_type: blob.storage_type)
      end
    end

    class Result
      attr_reader :data, :metadata, :errors

      def initialize(success:, data: nil, metadata: nil, errors: [])
        @success = success
        @data = data
        @metadata = metadata
        @errors = errors
      end

      def success?
        @success
      end
    end
  end
end
