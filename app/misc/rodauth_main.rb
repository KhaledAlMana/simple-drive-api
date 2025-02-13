require "sequel/core"

class RodauthMain < Rodauth::Rails::Auth
  configure do
    # List of authentication features that will be enabled
    enable :create_account,
           :login,
           :logout,
           :jwt,
           :json,
           :lockout,
           :jwt_refresh

    # ==> Routes
    prefix "/api/v1/auth"
    create_account_route "register"
    jwt_refresh_route "refresh-token"

    # ==> General
    # Initialize Sequel and have it reuse Active Record's database connection.
    db Sequel.sqlite(extensions: :activerecord_connection, keep_reference: false)
    # Avoid DB query that checks accounts table schema at boot time.
    convert_token_id_to_integer? { Account.columns_hash["id"].type == :integer }

    # JWT secret for token generation
    jwt_secret ENV.fetch("SECRET_KEY_BASE")

    # HMAC secret for password reset tokens
    hmac_secret ENV.fetch("SECRET_KEY_BASE")

    # Account path configuration
    accounts_table :accounts
    account_password_hash_column :password_hash

    # JWT configuration
    json_response_success_key "success"
    json_response_custom_error_status? true
    only_json? true

    # JWT configuration
    jwt_algorithm "HS256"
    jwt_access_token_period { 3600 } # 1 hour
    allow_refresh_with_expired_jwt_access_token? false
    no_matching_login_message "Invalid login credentials"
    invalid_password_message "Invalid login credentials"

    # Rate limiting
    max_invalid_logins 5
  end
end
