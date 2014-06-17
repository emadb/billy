class AddActiveToJobOrderActivity < ActiveRecord::Migration
  def change
    add_column :job_order_activities, :active, :boolean
  end
end
