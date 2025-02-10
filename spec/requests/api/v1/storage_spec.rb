require 'swagger_helper'

RSpec.describe 'Storage API', type: :request do
  path '/api/v1/storage' do
    get 'Lists all files' do
      tags 'Storage'
      produces 'application/json'

      response '200', 'files found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              file_type: { type: :string },
              size: { type: :integer }
            }
          }
        run_test!
      end
    end
  end
end
