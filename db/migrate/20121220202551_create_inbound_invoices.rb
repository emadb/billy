class CreateInboundInvoices < ActiveRecord::Migration
  def change
    create_table :inbound_invoices do |t|
      t.string :customer
      t.string :number
      t.date :date
      t.date :due_date
      t.float :total
      t.float :tax
      t.float :taxable_income
      t.text :notes

      t.timestamps
    end
  end
end
