class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.string :description
      t.float :amount
      t.references :invoice

      t.timestamps
    end
    add_index :invoice_items, :invoice_id
  end
end
