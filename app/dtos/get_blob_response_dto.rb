class GetBlobResponseDTO
  include ActiveModel::Model
  include ActiveModel::Attributes
  attr_accessor :id, :data, :size, :created_at
end
