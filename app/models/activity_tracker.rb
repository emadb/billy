class ActivityTracker < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  belongs_to :user
  belongs_to :job_order_activity
  #attr_accessor :user, :job_order_activity, :time, :notes, :date, :start_time, :stop_time
  scope :today, -> { where(date: Date.today).where(status: ActivityTracker.untracked) }

  def self.untracked
    1
  end
  def self.tracked
    2
  end
end
