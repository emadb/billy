class AddAttachmentsToExpenses < ActiveRecord::Migration
   def self.up
    add_attachment :expenses, :attachment
  end

  def self.down
    remove_attachment :expenses, :attachment
  end
end
