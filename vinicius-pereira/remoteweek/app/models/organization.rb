class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :standups, dependent: :destroy
  has_many :weekly_reports, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def current_weekly_report
    weekly_reports.find_by(week_start: Date.current.beginning_of_week(:monday))
  end

  def standups_for_week(week_start)
    week_start = week_start.to_date
    standups.where(date: week_start..week_start.end_of_week(:monday))
  end
end
