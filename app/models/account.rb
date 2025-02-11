class Account < ApplicationRecord
  include Rodauth::Rails.model

  validates :email, presence: true, uniqueness: true
  validates :status, presence: true

  # Add any additional associations or validations here
  has_many :audits, as: :auditable
end
