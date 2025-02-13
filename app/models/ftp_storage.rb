class FTPSstorage < ApplicationRecord
  include Auditable
  validates :id, presence: true, uniqueness: true
  validates :path, presence: true
  validates :host, presence: true # This is the FTP server host:port
  validates :blob_id, presence: true, uniqueness: true
end
