# config/initializers/oas_rails.rb
OasRails.configure do |config|
  # Basic Information about the API
  config.info.title = "Simple Drive API"
  config.info.version = "1.0.0"
  config.info.summary = "Simple Drive API to upload and download files"
  config.info.description = <<~HEREDOC
    # Welcome to OasRails

    OasRails automatically generates interactive documentation for your Rails APIs using the OpenAPI Specification 3.1 (OAS 3.1) and displays it with a nice UI.

    ## Getting Started

    You've successfully mounted the OasRails engine. This default documentation is based on your routes and automatically gathered information.

    ## Enhancing Your Documentation

    To customize and enrich your API documentation:

    1. Generate an initializer file:

      ```
      rails generate oas_rails:config
      ```
    2. Edit the created `config/initializers/oas_rails.rb` file to override default settings and add project-specific information.

    3. Use Yard tags in your controller methods to provide detailed API endpoint descriptions.

    ## Features

    - Upload and download files (base64 encoded)
    - Configurable interface to store files in one of the following locations:
      - [x] Local storage (default)
      - [x] Amazon S3
      - [x] Database
      - [ ] FTP
    - Basic consumer management

    Explore your API documentation and start building amazing things!

    For more information and advanced usage, visit the [OasRails GitHub repository](https://github.com/a-chacon/oas_rails).
  HEREDOC
  config.info.contact.name = "Khaled Almana"
  config.info.contact.email = ""
  config.info.contact.url = "https://khaled.sh"

  # Servers Information. For more details follow: https://spec.openapis.org/oas/latest.html#server-object
  config.servers = [ { url: "http://localhost:3000", description: "Local" } ]

  # Tag Information. For more details follow: https://spec.openapis.org/oas/latest.html#tag-object
  config.tags = [ {  name: "Blobs", description: "Upload and download files"  } ]

  # Optional Settings (Uncomment to use)

  # Extract default tags of operations from namespace or controller. Can be set to :namespace or :controller
  config.default_tags_from = :controller

  # Automatically detect request bodies for create/update methods
  # Default: true
  # config.autodiscover_request_body = false

  # Automatically detect responses from controller renders
  # Default: true
  # config.autodiscover_responses = false

  # API path configuration if your API is under a different namespace
  # config.api_path = "/"

  # Apply your custom layout. Should be the name of your layout file
  # Example: "application" if file named application.html.erb
  # Default: false
  # config.layout = "application"

  # Excluding custom controlers or controlers#action
  # Example: ["projects", "users#new"]
  # config.ignored_actions = []

  # #######################
  # Authentication Settings
  # #######################

  # Whether to authenticate all routes by default
  # Default is true; set to false if you don't want all routes to include secutrity schemas by default
  # config.authenticate_all_routes_by_default = true

  # Default security schema used for authentication
  # Choose a predefined security schema
  # [:api_key_cookie, :api_key_header, :api_key_query, :basic, :bearer, :bearer_jwt, :mutual_tls]
  config.security_schema = :bearer_jwt

  # Custom security schemas
  # You can uncomment and modify to use custom security schemas
  # Please follow the documentation: https://spec.openapis.org/oas/latest.html#security-scheme-object
  #
  # config.security_schemas = {
  #  bearer: {
  #   "type": "apiKey",
  #   "name": "Authorization",
  #   "in": "header"
  #  }
  # }

  # ###########################
  # Default Responses (Errors)
  # ###########################

  # The default responses errors are setted only if the action allow it.
  # Example, if you add forbidden then it will be added only if the endpoint requires authentication.
  # Example: not_found will be setted to the endpoint only if the operation is a show/update/destroy action.
  # config.set_default_responses = true
  # config.possible_default_responses = [:not_found, :unauthorized, :forbidden]
  # config.response_body_of_default = { message: String }
end
