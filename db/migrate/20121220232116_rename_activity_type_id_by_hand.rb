class RenameActivityTypeIdByHand < ActiveRecord::Migration
 def change
    change_table :user_activities do |t|
      t.rename :activity_type_id, :user_activity_type_id
    end
  end
end
