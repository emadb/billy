class CreateActivityTrackers < ActiveRecord::Migration
  def change
    create_table :activity_trackers do |t|
      t.integer :user_id
      t.integer :job_order_activity_id
      t.string :time
      t.string :notes
      t.date :date
      t.time :start_time
      t.time :stop_time

      t.timestamps
    end
  end
end
