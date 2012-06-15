class Address
  include Mongoid::Document
  embedded_in :customer
  field :street, :type => String
  field :zip_code, :type => String
  field :city, :type => String
  field :province, :type => String

  #accepts_nested_attributes_for :user
end
