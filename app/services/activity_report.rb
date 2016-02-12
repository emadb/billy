 class ActivityReport

  class ReportRow
    attr_accessor :date, :working_hours, :holiday_hours
    def initialize(date)
      @date = date    
    end
  end


  def self.report_2 (year, month, user_id)
    from_date = Date.new(year, month, 1)
    to_date = from_date + 1.month
    
    activities = ActiveRecord::Base.connection.select_all("
      select date, user_activity_type_id, sum(hours) as hours
      from user_activities
      where date >= '#{from_date.strftime('%Y-%m-%d')}' and date <= '#{to_date.strftime('%Y-%m-%d')}'
      and user_id = #{user_id}
      group by date, user_activity_type_id
      order by date")

    @formatted_activities = []
    (from_date..to_date).each do |d|
      r = ReportRow.new(d)
      @formatted_activities << r
      activities_of_the_day = activities.select {|f| f['date'] == d.to_s}
      activities_of_the_day.each do |a|
        if a['user_activity_type_id'].to_s == UserActivityType.working_id.to_s
          r.working_hours = a['hours']
        else
          r.holiday_hours = a['hours']
        end
      end
    end
    @formatted_activities
  end

    def self.report_presenze (year, month)
    from_date = Date.new(year, month, 1)
    to_date = from_date + 1.month

    @formatted_activities = []
    
    User.all.each do |u|  
      activities = ActiveRecord::Base.connection.select_all("
      select date, user_activity_type_id, sum(hours) as hours
      from user_activities
      where date >= '#{from_date.strftime('%Y-%m-%d')}' and date <= '#{to_date.strftime('%Y-%m-%d')}'
      and user_id = #{u.id}
      group by date, user_activity_type_id
      order by date")
    
      (from_date..to_date).each do |d|
        r = ReportRow.new(d)
        @formatted_activities << r
        activities_of_the_day = activities.select {|f| f['date'] == d.to_s}
        activities_of_the_day.each do |a|
          if a['user_activity_type_id'].to_s == UserActivityType.working_id.to_s
            r.working_hours = a['hours']
          else
            r.holiday_hours = a['hours']
          end
        end
      end
    end
    Rails.logger.info 'EMA'
    Rails.logger.info @formatted_activities
    
    @formatted_activities
  end


end