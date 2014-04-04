class Expense < ActiveRecord::Base
  belongs_to :expense_type
  belongs_to :user_activity
  belongs_to :user
  attr_accessible :description, :date, :amount, :notes, :activity, :user

  def expense_type_description
    expense_type.description unless expense_type.nil?
  end

  def self.get(year, month, selected_user_id)
    if (year.nil? or month.nil?)
      filter_date  = Date.today
    else
      filter_date= Date.new(year.to_i, month.to_i, 1)
    end

    filter_date_next = filter_date + 1.month

    query = Expense
      .where('date >= ? and date <= ? and user_id = ?', filter_date, filter_date_next, selected_user_id)
      .order('date')
  end

end