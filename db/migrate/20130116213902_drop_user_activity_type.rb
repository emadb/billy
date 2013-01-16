class DropUserActivityType < ActiveRecord::Migration
  def up
    drop_table :user_activity_types
  end

  def down
    create_table :user_activity_types do |t|
      t.string :description

      t.timestamps
    end
  end
end
