class ExpensesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
    @user_id = current_user.id
    @filter_date = DateTime.now    
    @users = load_users
    if params[:user_activity_id].nil?
      @expenses = Expense.get(nil, nil, current_user.id)
      @subtitle = @filter_date.strftime("%B")
    else
      @expenses = Expense.get_by_activity(params[:user_activity_id], current_user.id)
      activity = UserActivity.find(params[:user_activity_id])
      @subtitle = "#{activity.job_order_activity.job_order.code} - #{activity.job_order_activity.description} "
    end
  end

  def filter
    @user_id = params[:user] || current_user.id
    @filter_date = parse_filter(params[:date])
    @users = load_users
    @expenses = Expense.get(params[:date][:year], params[:date][:month], @user_id)    
    @subtitle = @filter_date.strftime("%B")
    render :template => 'expenses/index'
  end

  def parse_filter (params)
    if (params[:year].nil? or params[:month].nil?)
      Date.today
    else
      Date.new(params[:year].to_i, params[:month].to_i, 1)
    end
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
      @expense.date = @expense.user_activity.date
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

  def destroy
    Expense.find(params[:id]).destroy
     redirect_to :action => 'index'
  end
  
end
