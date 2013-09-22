class AddPriceToJobOrder < ActiveRecord::Migration
  def change
    add_column :job_orders, :price, :decimal
  end
end
