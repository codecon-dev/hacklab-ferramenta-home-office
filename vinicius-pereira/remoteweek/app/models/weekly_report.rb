class WeeklyReport < ApplicationRecord
  belongs_to :organization

  validates :week_start, presence: true
  validates :week_end, presence: true
  validates :week_start, uniqueness: { scope: :organization_id }

  scope :recent_first, -> { order(week_start: :desc) }

  def week_range
    "#{week_start} – #{week_end}"
  end

  def data
    report_data || {}
  end

  def members_data
    data["members"] || []
  end
end
