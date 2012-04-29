class Foo
  include Mongoid::Document
  field :name, :type => String
  field :published, :type => Boolean
  field :customer_id, :type => Integer
end
