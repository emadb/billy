class Expense < ActiveRecord::Base
  belongs_to :expense_type
  belongs_to :user_activity
  belongs_to :user
  has_attached_file :attachment, :styles => {
      :thumb => "100x100#",
      :small  => "150x150>",
      :medium => "200x200" },
      :default_url => "/missing.png",
      s3_credentials: lambda { |attachment| attachment.instance.s3_keys }
  validates_attachment_content_type :attachment, :content_type => [/\Aimage\/.*\Z/, 'application/pdf' ]
  attr_accessible :description, :date, :amount, :notes, :activity, :user, :attachment, :user_activity_id, :expense_type_id

  def s3_keys
  {
    bucket: AppSettings.s3_bucket,
    access_key_id: AppSettings.s3_access_key_id, 
    secret_access_key: AppSettings.s3_secret_access_key 
  }
  end

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

    Expense
      .where('date >= ? and date <= ? and user_id = ?', filter_date, filter_date_next, selected_user_id)
      .order('date')
  end

  def self.get_by_activity(user_activity_id, user_id)
    Expense
      .where('user_activity_id = ? and user_id = ?', user_activity_id, user_id)
      .order('date')
  end

end