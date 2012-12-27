class UserActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :job_order_activity
  belongs_to :user_activity_type
  attr_accessible :date, :description, :hours


  def self.get(year, month, selected_user_id)
    if (year.nil? or month.nil?)
      filter_date  = Date.today
    else
      filter_date= Date.new(year.to_i, month.to_i, 1)
    end
    filter_date_next = filter_date.to_time.advance(:months => 1).to_date

    query = UserActivity
      .where('date >= ? and date <= ? and user_id = ?', filter_date, filter_date_next, selected_user_id)
      .order('date')
  end

  def self.find_by_user_and_date(userId, date)
    UserActivity
    .where('date = ? and user_id = ?', date, userId)
	.sum(:hours) || 0
  end
end
