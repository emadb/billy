class UserActivity
  include Mongoid::Document
  embeds_one :user
  embeds_one :activity
  embeds_one :user_activity_type
  field :date, :type => Date
  field :hours, :type => Float
  field :description

  accepts_nested_attributes_for :user, :activity, :user_activity_type

  def self.get(year, month, selected_user_email)
    if (year.nil? or month.nil?)
      filter_date  = Date.today
    else
      filter_date= Date.new(year.to_i, month.to_i, 1)
    end
    filter_date_next = filter_date.to_time.advance(:months => 1).to_date
   
    query = UserActivity
      .where(:date.gte => filter_date)
      .where(:date.lte => filter_date_next)
      .where("user.email" => selected_user_email)
      .order_by([:date, :asc])
  end
end