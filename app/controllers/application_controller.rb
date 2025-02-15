class ApplicationController < ActionController::API
  before_action :set_default_format
  before_action :set_version
  around_action :set_current_user

  private
  def set_current_user
    Current.user = current_account
    yield
  ensure
    Current.user = nil
  end

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

  def current_account
    rodauth.rails_account
  end
end
