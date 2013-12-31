class AddIsWorkingToUserActivityType < ActiveRecord::Migration
  def change
    add_column :user_activity_types, :isWorking, :boolean, :default => false
  end
end
