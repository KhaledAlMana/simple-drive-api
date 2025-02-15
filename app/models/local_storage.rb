class LocalStorage < ApplicationRecord
  include Auditable
  validates :full_path, presence: true
  validates :blob_id, presence: true, uniqueness: true
end
