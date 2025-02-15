module Auditable
  extend ActiveSupport::Concern
  include SoftDeletable

  included do
    belongs_to :created_by, class_name: "Account", optional: true
    belongs_to :updated_by, class_name: "Account", optional: true

    before_create :set_created_by
    before_save :set_updated_by, if: :changed?

    # validates :created_by, presence: true, on: :create
    validates :updated_by, presence: true, on: :update, if: :changed?
  end

  private

  def set_created_by
    raise "No user context found for auditing" unless Current.user.present?

    transaction do
      self.created_by = Current.user
      self.updated_by = Current.user
    end
  end

  def set_updated_by
    return if will_save_change_to_deleted_at? # Don't update audit trail on soft delete
    raise "No user context found for auditing" unless Current.user.present?

    transaction do
      self.updated_by = Current.user
    end
  end
end
