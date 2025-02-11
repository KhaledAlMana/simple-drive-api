require "sequel/core"

class RodauthMain < Rodauth::Rails::Auth
  configure do
    # List of authentication features that will be enabled
    enable :create_account,
           :login,
           :logout,
           :jwt,
           :json,
           :lockout


    # ==> General
    # Initialize Sequel and have it reuse Active Record's database connection.
    db Sequel.sqlite(extensions: :activerecord_connection, keep_reference: false)
    # Avoid DB query that checks accounts table schema at boot time.
    convert_token_id_to_integer? { Account.columns_hash["id"].type == :integer }


    # JWT secret for token generation
    jwt_secret ENV.fetch("secret_key_base")

    # HMAC secret for password reset tokens
    hmac_secret ENV.fetch("secret_key_base")

    # Account path configuration
    accounts_table :accounts
    account_password_hash_column :password_hash

    # JWT configuration
    json_response_success_key "success"
    json_response_custom_error_status? true
    only_json? true

    # Rate limiting
    max_invalid_logins 5
  end
end
