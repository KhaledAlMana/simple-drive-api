Dir[Rails.root.join("app/lib/dtos/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/lib/utils/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/features/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/services/**/*.rb")].each { |f| require f }
STORAGE_TYPE = ENV.fetch("STORAGE_TYPE", :local).to_sym
puts "STORAGE_TYPE: #{STORAGE_TYPE}"
