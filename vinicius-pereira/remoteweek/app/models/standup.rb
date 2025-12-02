class Standup < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :date, presence: true
  validates :date, uniqueness: { scope: :user_id }

  before_validation :set_organization_from_user, if: -> { user.present? && organization_id.nil? }

  scope :recent_first, -> { order(date: :desc) }
  scope :for_week, ->(week_start) {
    week_start = week_start.to_date
    where(date: week_start..week_start.end_of_week(:monday))
  }

  def set_organization_from_user
    self.organization_id ||= user.organization_id
  end
end
