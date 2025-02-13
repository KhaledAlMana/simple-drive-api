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

        GetBlobResponseDTO.new(
          id: blob.id,
          data: data,
          size: blob.byte_size,
          created_at: blob.created_at
        )
      rescue ActiveRecord::RecordNotFound
        ::APIResponse.error_response("Blob not found", :not_found)
      rescue StandardError => e
        ::APIResponse.error_response(e.message, :unprocessable_entity)
      end

      private

      def find_blob
        BlobAggregate.find_by!(key: @dto.key)
      end

      def download_blob_data(blob)
        strategy = StorageStrategy.new
        io = strategy.download(blob_id: blob.id)
        Base64.strict_encode64(io.read)
      ensure
        io&.close
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
