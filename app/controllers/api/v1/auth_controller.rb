# This controller is responsible for documentations only - Rodauth will overwrite anyways.
class Api::V1::AuthController < ApplicationController
  # POST /create-account
  # Creates a new user account
  # Routes:
  #   rodauth.create_account_route #=> "create-account"
  #   rodauth.create_account_path #=> "/create-account"
  #   rodauth.create_account_url #=> "https://example.com/create-account"
  # Request:
  #   {
  #     "login": "user@example.com",
  #     "login-confirm": "user@example.com",
  #     "password": "secret123",
  #     "password-confirm": "secret123"
  #   }
  # Response:
  #   200 OK: { "jwt": "eyJhbGciOiJIUzI1..." }
  #   422 Unprocessable: { "error": "passwords do not match" }
  # @request_body login [String] The user's email address
  # @request_body "login-confirm" [String] The user's email address (confirmation)
  # @request_body password(body) [String] The user's password
  # @request_body password-confirm(body) [String] The user's password (confirmation)
  def create_account
    rodauth.create_account
    json rodauth.session_jwt
  end

  # POST /login
  # Authenticates user credentials
  # Routes:
  #   rodauth.login_route #=> "login"
  #   rodauth.login_path #=> "/login"
  #   rodauth.login_url #=> "https://example.com/login"
  # Request:
  #   {
  #     "login": "user@example.com",
  #     "password": "secret123"
  #   }
  # Response:
  #   200 OK: { "jwt": "eyJhbGciOiJIUzI1..." }
  #   401 Unauthorized: { "error": "invalid password" }
  #   403 Forbidden: { "error": "account locked out" }
  # @request_body login [String] The user's email address
  # @request_body password [String] The user's password
  def login
  end

  # POST /logout
  # Invalidates the current session
  # Routes:
  #   rodauth.logout_route #=> "logout"
  #   rodauth.logout_path #=> "/logout"
  #   rodauth.logout_url #=> "https://example.com/logout"
  # Request: {} (empty body, requires JWT in Authorization header)
  # Response:
  #   200 OK: { "success": true }
  #   401 Unauthorized: { "error": "not logged in" }
  def logout
  end

  # POST /jwt-refresh
  # Refresh JWT access token using refresh token
  # Routes:
  #   rodauth.jwt_refresh_route #=> "jwt-refresh"
  #   rodauth.jwt_refresh_path #=> "/jwt-refresh"  #   rodauth.jwt_refresh_url #=> "https://example.com/jwt-refresh"  # Request:
  #   {
  #     "refresh_token": "your_refresh_token_here"
  #   }
  # Response:
  #   200 OK: {
  #     "access_token": "new_jwt_token",
  #     "refresh_token": "new_refresh_token"
  #   }
  #   401 Unauthorized: { "error": "invalid refresh token" }
  # @request_body refresh_token [String] The JWT refresh token
  def refresh_token
  end
end
