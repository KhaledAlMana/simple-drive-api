module Features
  module Blobs
    class Upload
      def initialize(dto)
        @dto = dto
      end

      def call
        ActiveRecord::Base.transaction do
          blob = create_blob
          store_blob_data(blob.id)
        end
        ::APIResponse.json_response({}, :created)
      rescue StandardError => e
        # TODO: set a proper error message for the response and not the exception message
        ::APIResponse.error_response(e.message, :unprocessable_entity)
      end

      private
      def create_blob
        BlobAggregate.create!(
          key: @dto.id,
          byte_size: ::BlobUtils.decode_base64(@dto.data).size,
          checksum: ::BlobUtils.compute_checksum(@dto.data),
          storage_type: StorageType.get_selected_storage_type
        )
      end

      def store_blob_data(blob_id)
        ::StorageStrategy.new.upload(
          base64_data: @dto.data,
          blob_id: blob_id
        )
      end
    end
  end
end
