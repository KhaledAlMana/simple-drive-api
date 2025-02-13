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
    puts "rodauth.rails_account: #{rodauth.rails_account}"
    raise "No user context found for auditing" unless rodauth.rails_account?

    transaction do
      self.created_by = rodauth.rails_account
      self.updated_by = rodauth.rails_account
    end
  end

  def set_updated_by
    return if will_save_change_to_deleted_at? # Don't update audit trail on soft delete
    raise "No user context found for auditing" unless rodauth.rails_account.present?

    transaction do
      self.updated_by = rodauth.rails_account
    end
  end
end
