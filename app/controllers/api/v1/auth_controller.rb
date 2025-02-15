# This controller is responsible for documentations only - Rodauth will overwrite anyways.
class Api::V1::AuthController < ApplicationController
  # POST /create-account routes to Rodauth's create_account method
  # @tags v1 Auth
  # @summary Register
  # @request_body The user to be created. At least include an `email`. [Hash]{ "login": "user@example.com", "login-confirm": "user@example.com", "password": "secret123", "password-confirm": "secret123" }
  # @request_body_example basic user [Hash] { "login": "user@example.com", "login-confirm": "user@example.com", "password": "secret123", "password-confirm": "secret123" }
  # @response Success(200) [Hash{access_token: "eyJhbGciOiJIUzI1...", refresh_token: "eyJhbGciOiJIUzI1..." , success: "Account created successfully" }]
  def create_account
  end

  # POST /login routes to Rodauth's login method
  # @tags v1 Auth
  # @summary Login
  # @request_body Login [Hash] { "login": "user@example.com", "password": "secret123" }
  # @request_body_example basic user [Hash] { "login": "user@example.com", "password": "secret123" }
  # @response Success(200) [Hash{ access_token: "eyJhbGciOiJIUzI1...", refresh_token: "eyJhbGciOiJIUzI1..." , success: "You are now logged in" }]
  def login
  end

  # POST /logout routes to Rodauth's logout method
  # @tags v1 Auth
  # @summary Logout
  # @request_body Logout [Hash] {}
  # @response Success(200) [Hash{ success: String }] { success: "You are now logged out" }
  # @response Error(401) [Hash{ "error": "not logged in" }]
  def logout
  end

  # POST /refresh-token routes to Rodauth's refresh_token method
  # @tags v1 Auth
  # @summary Refresh Tokens
  # @request_body Refresh Token [Hash{ refresh_token: String }]
  # @response Success(200) [Hash{ access_token: "eyJhbGciOiJIUzI1...", refresh_token: "eyJhbGciOiJIUzI1..." }]
  def refresh_token
  end
end
