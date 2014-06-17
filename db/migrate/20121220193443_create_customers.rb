class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :vat_core
      t.string :email
      t.string :address_street
      t.string :address_zip_code
      t.string :address_city
      t.string :address_province

      t.timestamps
    end
  end
end
