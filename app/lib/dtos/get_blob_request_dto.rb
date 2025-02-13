class GetBlobRequestDTO
  include ActiveModel::Validations
  attr_reader :key

  validates :key, presence: true

  def initialize(key: nil)
    @key = key
  end
end
