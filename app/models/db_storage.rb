class DbStorage < ApplicationRecord
  include Auditable
  validates :data, presence: true
  validates :blob_id, presence: true, uniqueness: true
end
