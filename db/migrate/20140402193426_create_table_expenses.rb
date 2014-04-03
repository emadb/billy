class CreateTableExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :description
      t.float :amount
      t.date :date
      t.references :user_activity
      t.text :notes
      t.references :expense_type

      t.timestamps      
    end
  end
end

