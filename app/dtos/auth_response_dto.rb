class AuthResponseDTO
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :access_token, :refresh_token

  validates :access_token, presence: true
end
