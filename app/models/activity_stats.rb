class ActivityStats
  attr_accessor :today_hours, :yesterday_hours
  # todo: show current month (incomplete days)
  def initialize 
    @today_hours = 0
    @yesterday_hours = 0 
  end
end