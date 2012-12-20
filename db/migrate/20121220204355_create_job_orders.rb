class CreateJobOrders < ActiveRecord::Migration
  def change
    create_table :job_orders do |t|
      t.string :code
      t.text :notes
      t.float :hourly_rate
      t.boolean :archived?
      t.references :customer

      t.timestamps
    end
    add_index :job_orders, :customer_id
  end
end
