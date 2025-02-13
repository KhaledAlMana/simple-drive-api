class DbStorage < ApplicationRecord
  include Auditable

  validates :id, presence: true, uniqueness: true
  validates :data, presence: true
  validates :blob_id, presence: true, uniqueness: true
end
