class CreateUserActivityTypes < ActiveRecord::Migration
  def change
    create_table :user_activity_types do |t|
      t.string :description

      t.timestamps
    end
  end
end
