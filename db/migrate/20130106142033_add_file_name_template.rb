class AddFileNameTemplate < ActiveRecord::Migration
   def change
    add_column :customers, :file_name_template, :string
  end
end
