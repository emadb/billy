class ExpensesController < ApplicationController
  def index
    @expenses = Expense.where('user_id = ?', current_user.id)
    @users = load_users
  end

  def load_users
    if (current_user.admin?)
      User.all
    else
      [current_user]  
    end
  end


  def new
    @expense = Expense.new
    @types = ExpenseType.all
    if !params[:user_activity_id].nil?
      @expense.user_activity = UserActivity.find(params[:user_activity_id])
    end
  end

  def create
    @expense = Expense.new(params[:expense])
    @expense.user = current_user
    @expense.expense_type = ExpenseType.find(params[:expense][:expense_type_id])
    if !params[:expense][:user_activity_id].nil?
      @expense.user_activity = UserActivity.find(params[:expense][:user_activity_id])
    end
    @expense.save
    redirect_to expenses_path
  end

  def edit
    @expense = Expense.find(params[:id])
    @types = ExpenseType.all
  end

  def update
    @expense = Expense.find(params[:id])
    @expense.update(params[:expense])
    @expense.expense_type = ExpenseType.find(params[:expense][:expense_type_id])
    @expense.save
    redirect_to expenses_path
  end
  
end
