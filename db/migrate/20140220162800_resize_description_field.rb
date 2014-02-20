class ResizeDescriptionField < ActiveRecord::Migration
  def change
    change_column :user_activities, :description, :text
  end
end
