class S3Storage < ApplicationRecord
  include Auditable
  # In need to make files accessible at all time, it's
  # better to hold all s3 config of each blob (endpoint, region, bucket, key).
  # However, due to the simplicity of the project, we can just stop here.
  validates :bucket, presence: true
  validates :key, presence: true, uniqueness: { scope: :bucket }
  validates :region, presence: true
  validates :blob_id, presence: true
end
