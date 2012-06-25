class UserActivity
  include Mongoid::Document
  embeds_one :user
  embeds_one :activity
  embeds_one :activity_type
  field :date, :type => DateTime
  field :hours, :type => Float
  field :description

  accepts_nested_attributes_for :user, :activity, :activity_type
end