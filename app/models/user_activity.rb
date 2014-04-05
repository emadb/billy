class UserActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :job_order_activity
  belongs_to :user_activity_type
  has_many :expenses
  attr_accessible :date, :description, :hours


  def self.get(year, month, selected_user_id)
    if (year.nil? or month.nil?)
      filter_date  = Date.today
    else
      filter_date= Date.new(year.to_i, month.to_i, 1)
    end
    filter_date_next = filter_date + 1.month

    query = UserActivity
      .includes(:expenses)
      .where('date >= ? and date <= ? and user_id = ?', filter_date, filter_date_next, selected_user_id)
      .order('date')
  end

  def self.find_by_user_and_date(userId, date)
    UserActivity
    .where('date = ? and user_id = ?', date, userId)
	.sum(:hours) || 0
  end

  def job_order_id
    if !job_order_activity.nil?
      job_order_activity.job_order.id
    end
  end

  def as_json(options = { })
    h = super(options)
    h[:job_order_id] = job_order_id
    h
  end

  def cost
    self.hours * self.user.hourly_cost
  end

  def working?
    self.user_activity_type.working?
  end

end
