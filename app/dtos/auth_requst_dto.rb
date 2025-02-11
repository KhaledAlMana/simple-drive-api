class AuthRequestDTO
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :email, :password
end
