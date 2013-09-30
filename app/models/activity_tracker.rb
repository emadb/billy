class ActivityTracker < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  belongs_to :user
  belongs_to :job_order_activity
  #attr_accessor :user, :job_order_activity, :time, :notes, :date, :start_time, :stop_time
  scope :today, -> { where(date: Date.today) }
end
