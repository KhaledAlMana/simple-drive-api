class UploadBlobRequestDTO
  include ActiveModel::Validations

  attr_reader :id, :data

  validates :id, presence: true
  validates :data, presence: true
  validate :validate_base64_encoding

  def initialize(id:, data:)
    @id = id
    @data = data
  end

  private

  def validate_base64_encoding
    return if data.nil?
    begin
      Base64.strict_decode64(data)
      true
    rescue ArgumentError
      errors.add(:data, "must be valid base64 encoded")
      false
    end
  end
end
