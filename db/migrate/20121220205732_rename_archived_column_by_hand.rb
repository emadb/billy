class RenameArchivedColumnByHand < ActiveRecord::Migration
 def change
    change_table :job_orders do |t|
      t.rename :archived?, :archived
    end
  end
end
