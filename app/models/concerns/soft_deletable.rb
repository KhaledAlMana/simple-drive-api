module SoftDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }
    scope :with_deleted, -> { unscope(where: :deleted_at) }
    scope :only_deleted, -> { with_deleted.where.not(deleted_at: nil) }

    belongs_to :deleted_by, class_name: "Account", optional: true

    validates :deleted_by, presence: true, if: :deleted?
  end

  def soft_delete!(user = Current.user)
    return false if deleted?

    transaction do
      update!(
        deleted_at: Time.current,
        deleted_by: user
      )
    end
  end

  def restore!(user = Current.user)
    return false unless deleted?

    transaction do
      update!(
        deleted_at: nil,
        deleted_by: nil
      )
    end
  end

  def deleted?
    deleted_at.present?
  end
end
