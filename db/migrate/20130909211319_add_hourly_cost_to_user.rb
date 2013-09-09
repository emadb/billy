class AddHourlyCostToUser < ActiveRecord::Migration
  def change
    add_column :users, :hourly_cost, :float
  end
end
