Dir[Rails.root.join("app/lib/dtos/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/lib/utils/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/features/**/*.rb")].each { |f| require f }
