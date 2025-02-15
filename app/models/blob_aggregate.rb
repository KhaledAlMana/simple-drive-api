class BlobAggregate < ApplicationRecord
  include Auditable
  # validates :id, presence: true, uniqueness: true # conflicts with the UUID generation
  validates :key, presence: true, uniqueness: true # This is the key that is used to reference the blob as per the requirements
  # validates :filename, presence: true # Since it's only a blob, we don't have a filename
  # validates :content_type, presence: true # Since it's only a blob, we don't have a content type too
  validates :byte_size, presence: true, numericality: { greater_than: 0 }
  validates :checksum, presence: true
  validates :storage_type, presence: true, inclusion: { in: StorageType.types.keys.map(&:to_s) }

  has_one :localstorage, class_name: "LocalStorage", foreign_key: "blob_id", dependent: :destroy
  has_one :s3storage, class_name: "S3Storage", foreign_key: "blob_id", dependent: :destroy
  has_one :dbstorage, class_name: "DbStorage", foreign_key: "blob_id", dependent: :destroy
  has_one :ftpstorage, class_name: "FTPStorage", foreign_key: "blob_id", dependent: :destroy
end
