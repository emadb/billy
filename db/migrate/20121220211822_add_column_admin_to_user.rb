class AddColumnAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
  end
end
