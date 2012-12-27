class CreateJobOrderActivities < ActiveRecord::Migration
  def change
    create_table :job_order_activities do |t|
      t.string :description
      t.integer :estimated_hours
      t.references :job_order

      t.timestamps
    end
    add_index :job_order_activities, :job_order_id
  end
end
