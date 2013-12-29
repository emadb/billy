class CreateUserActivityType < ActiveRecord::Migration
  def change
    create_table :user_activity_types do |t|
      t.string :description
    end
  end
end
