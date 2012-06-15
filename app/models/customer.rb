class Customer
  include Mongoid::Document
  field :name, :type => String
  field :vat_code, :type => String
  
  field :email, :type => String
  
  embeds_one :address
  accepts_nested_attributes_for :address
  
  delegate :street, :to => :address
end