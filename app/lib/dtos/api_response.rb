module APIResponse
  class << self
    def json_response(object, status = :ok)
      { json: object, status: status }
    end

    def error_response(errors, status = :unprocessable_entity)
      { json: { errors: Array(errors) }, status: status }
    end
  end
end
