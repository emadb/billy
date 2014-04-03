class Expense < ActiveRecord::Base
  belongs_to :expense_type
  belongs_to :user_activity
  attr_accessible :description, :date, :amount, :notes, :activity

  def expense_type_description
    expense_type.description unless expense_type.nil?
  end
end