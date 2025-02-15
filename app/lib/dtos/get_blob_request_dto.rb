class GetBlobRequestDTO
  include ActiveModel::Validations
  attr_reader :id

  validates :id, presence: true

  def initialize(id: nil)
    @id = id
  end
end
