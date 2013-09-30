class AddStatusToActivityTracker < ActiveRecord::Migration
  def change
    add_column :activity_trackers, :status, :int
  end
end
