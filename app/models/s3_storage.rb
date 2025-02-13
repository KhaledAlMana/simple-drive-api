class S3Sstorage < ApplicationRecord
  include Auditable
  validates :id, presence: true, uniqueness: true
  validates :full_path, presence: true
  validates :blob_id, presence: true, uniqueness: true
end
