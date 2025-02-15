class GetBlobResponseDTO
  attr_accessor :id,
                :data,
                :size,
                :created_at

  def initialize(id:, data:, size:, created_at:)
    @id = id
    @data = data
    @size = size
    @created_at = created_at
  end
end
