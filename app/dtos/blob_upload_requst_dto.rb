class BlobUploadRequestDTO
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :id, :data

validates :id, presence: true
validates :data,
          presence: true,
          format: { with: /\A[A-Za-z0-9+\/]+={0,2}\z/, message: "must be base64 encoded" },
          if: -> { validate_base64_decoding }

private def validate_base64_decoding
    return if data.blank?
    begin
      Base64.strict_decode64(data)
      true
    rescue ArgumentError
      errors.add(:data, "must be valid base64 encoded")
      false
    end
  end
end
