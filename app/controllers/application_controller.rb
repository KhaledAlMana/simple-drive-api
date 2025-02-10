class ApplicationController < ActionController::API
  before_action :set_default_format
  before_action :set_version

  private

  def set_default_format
    request.format = :json
  end

  def set_version
    @api_version = request.headers["Accept-Version"] || "v1"
    if ![ "v1" ].include?(@api_version)
      render json: { error: "Invalid API version" }, status: :bad_request
    end
  end

  def api_version
    @api_version
  end
end
