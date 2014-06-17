class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :number
      t.date :date
      t.date :due_date
      t.integer :status
      t.float :total
      t.float :tax
      t.float :taxable_income
      t.boolean :has_tax
      t.text :notes
      t.boolean :is_payed
      t.references :customer

      t.timestamps
    end
    add_index :invoices, :customer_id
  end
end
