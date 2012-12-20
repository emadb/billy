class Customer < ActiveRecord::Base
	attr_accessible :address_city, :address_province, :address_street, :address_zip_code, :email, :name, :vat_core
end
