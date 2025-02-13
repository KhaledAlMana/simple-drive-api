class Api::V1::BlobsController < ApplicationController
  # Blob upload
  # @request_body id [String] The unique identifier for the blob
  # @request_body data [String] The base64-encoded blob data
  def upload
    dto = upload_blob_request_dto
    unless dto.valid?
      return APIResponse.error_response(dto.errors, :bad_request)
    end
     render Features::Blobs::Upload.new(dto).call
  end

  # Blob download
  # @parameter key(path) [String] The unique identifier for the blob.
  def download
    dto = ::GetBlobRequestDTO.new(key: params[:key])
    unless dto.valid?
      return ::APIResponse.error_response(dto.errors, :bad_request)
    end
    render ::Features::Blobs::Download.new(dto).call
  end

  private
  def upload_blob_request_dto
    UploadBlobRequestDTO.new(id: params.require(:blob).permit(:id, :data)[:id],
                data: params.require(:blob).permit(:id, :data)[:data])
  end
end
