module Features
  module Blobs
    class Upload
      def initialize(dto)
        @dto = dto
      end

      def call
        blob = create_blob
        store_blob_data(blob.id)
      rescue StandardError => e
        # TODO: set a proper error message for the response and not the exception message
        APIResponse.error_response(e.message, :unprocessable_entity)
      end

      private
      def create_blob
        BlobAggregate.create!(
          key: @dto.id,
          byte_size: ::BlobUtils.decode_base64(@dto.data).size,
          checksum: ::BlobUtils.compute_checksum(@dto.data),
          storage_type: StorageType.getSelectedStorageType
        )
      end

      def store_blob_data(blob_id)
        strategy = StorageStrategy.new
        strategy.upload(
          base64_data: @dto.data,
          blob_id: blob_id
        )
      end
    end
  end
end
