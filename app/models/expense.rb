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
      filter_date  = Date.new(DateTime.now.year, DateTime.now.month, 1)
    else
      filter_date= Date.new(year.to_i, month.to_i, 1)
    end

    filter_date_next = filter_date + 1.month

    query = Expense
      .includes(user_activity: [{job_order_activity: :job_order}])
      .where('expenses.date >= ? and expenses.date <= ? and expenses.user_id = ?', filter_date, filter_date_next, selected_user_id)
      .order('expenses.date')
  end

end