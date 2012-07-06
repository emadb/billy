class UserActivity
  include Mongoid::Document
  embeds_one :user
  embeds_one :activity
  embeds_one :user_activity_type
  field :date, :type => Date
  field :hours, :type => Float
  field :description

  accepts_nested_attributes_for :user, :activity, :user_activity_type
end