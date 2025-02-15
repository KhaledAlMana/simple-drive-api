class Api::V1::BlobsController < ApplicationController
  # Blob upload
  # @tags v1 Blobs
  # @summary Upload a blob
  # @request_body The blob to upload. [{"id": "string", "data": "string"}]
  # @request_body_example A complete User. [{"id": "string", "data": "string"}] { id: "any_valid_string_or_identifier", data: "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh" }
  # @response Uploaded(201) [Hash]
  # @response Error(400) [{ errors: Array<String> }]
  # @response_example Error(400) [{ errors: ["Id can't be blank"] }]
  # @response Error(422) [{ errors: Array<String> }]
  # @response_example Error(422) [{ errors: ["Key has already been taken"] }]
  def upload
    dto = upload_blob_request_dto
    unless dto.valid?
      return render ::APIResponse.error_response(dto.errors, :bad_request)
    end
     render Features::Blobs::Upload.new(dto).call
  end

  # Blob download
  # @tags v1 Blobs
  # @summary Download a blob
  # @parameter id(path) [String] The unique identifier for the blob.
  # @response Error(404)  [{ errors: Array<String> }]
  # @response_example Error(404) [{ errors: ["Blob not found"] }]
  # @response Error(400) [{ errors: Array<String> }]
  # @response_example Error(400) [{ errors: ["Id can't be blank"] }]
  # @response Success(200) [Hash{ id: String, data: String, size: Integer, created_at: DateTime }]
  # @response_example Success(200) [{ id: "any_valid_string_or_identifier", data: "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh", size: 27, created_at: "2023-01-22T21:37:55Z" }]
  def download
    dto = ::GetBlobRequestDTO.new(id: params[:id])
    unless dto.valid?
      return render ::APIResponse.error_response(dto.errors, :bad_request)
    end
    render ::Features::Blobs::Download.new(dto).call
  end

  private
  def upload_blob_request_dto
    ::UploadBlobRequestDTO.new(id: params[:id], data: params[:data])
  end
end
