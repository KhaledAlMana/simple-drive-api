require 'swagger_helper'

RSpec.describe 'api/v1/blobs', type: :request do
  path '/api/v1/blobs' do
    post('upload blob') do
      consumes 'application/json'
      security [ { bearerAuth: {
          description: "JWT Token",
          name: 'Authorization',
          in: :header,
          type: :bearer,
          bearerFormat: 'JWT'
      } } ]
      parameter name: :blob_upload, in: :body, required: true
      response(201, "") do
      let(:Authorization) { token_for(user) }
      after do |example|
        example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
        }
      end
      run_test!
      end

      response(401, 'unauthorized') do
        run_test!
      end
    end
  end

  path '/api/v1/blobs/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('get blob') do
      security [ { bearerAuth: [] } ]
      parameter name: 'Authorization', in: :header, type: :string, required: true,
                description: 'Bearer token'

      response(200, 'successful') do
        let(:id) { '123' }
        let(:Authorization) { 'Bearer <token>' }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        let(:id) { '123' }
        run_test!
      end
    end
  end
end
