class User < ApplicationRecord
  belongs_to :organization
  has_many :standups, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # roles em string (compatível com seeds)
  enum role: {
    member:  "member",
    manager: "manager",
    admin:   "admin"
  }, _suffix: true

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= "member"
  end

  def standup_for(date)
    standups.find_by(date: date.to_date)
  end

  def standups_for_week(week_start)
    week_start = week_start.to_date
    standups.where(date: week_start..week_start.end_of_week(:monday))
  end
end
