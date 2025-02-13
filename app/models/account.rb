class Account < ApplicationRecord
  include Rodauth::Rails.model
  include Auditable

  validates :email, presence: true, uniqueness: true
  validates :status, presence: true
end
