module DateHelper
  class << self
    def new_years_day year
      Date.new(year.to_i, 1, 1)
    end
    def end_year year
      Date.new(year.to_i, 12, 31)
    end
  end
end
