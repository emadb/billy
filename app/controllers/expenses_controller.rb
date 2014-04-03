class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
  end

  def new
    @expense = Expense.new
    @types = ExpenseType.all
    if !params[:activity_id].nil?
      @expense.user_activity = UserActivity.find(params[:activity_id])
    end
  end

  def create
    @expense = Expense.new(params[:expense])
    @expense.expense_type = ExpenseType.find(params[:expense][:expense_type_id])
    if !params[:expense][:user_activity_id].nil?
      @expense.user_activity = UserActivity.find(params[:expense][:user_activity_id])
    end
    @expense.save
    redirect_to expenses_path
  end
  
end
