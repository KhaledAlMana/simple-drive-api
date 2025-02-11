class Api::V1::BlobsController < ApplicationController
    # POST /api/v1/blobs
    def upload
      render status: :created
    end

    # GET /api/v1/blobs/:id
    def get
      # mock data {
      # "id": "any_valid_string_or_identifier",
      # "data": "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh",
      # "size": "27",
      # "created_at": "2023-01-22T21:37:55Z"
      # }
      render json: {
        id: "any_valid_string_or_identifier",
        data: "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh",
        size: "27",
        created_at: "2023-01-22T21:37:55Z"
      }
    end
end
