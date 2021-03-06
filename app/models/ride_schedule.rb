class RideSchedule < ApplicationRecord
  belongs_to :travel_method
  has_one :week, as: :owner, dependent: :destroy
  has_many :alarms, dependent: :destroy

  validates :starts_at, :interval_minutes, presence: true
  validates_presence_of :week

  accepts_nested_attributes_for :week, allow_destroy: true, reject_if: :all_blank

  def title
    "#{travel_method.name} - #{abbreviated_weekdays} #{starts_at.strftime("%p")}"
  end

  def abbreviated_weekdays
    week.abbreviated_weekdays
  end

  def next_departure(departs_at)
    raise InvalidTimeError unless departs_at > starts_at

    departure = starts_at
    until departure >= starts_at
      departure += interval.minutes
    end
    return departure
  end
end
