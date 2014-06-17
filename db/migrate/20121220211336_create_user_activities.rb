class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.references :user
      t.references :job_order_activity
      t.references :activity_type
      t.date :date
      t.float :hours
      t.string :description

      t.timestamps
    end
    add_index :user_activities, :user_id
    add_index :user_activities, :job_order_activity_id
    add_index :user_activities, :activity_type_id
  end
end
