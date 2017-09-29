class CreateInboundInvoiceCategories < ActiveRecord::Migration
  def change
    create_table :inbound_invoice_categories do |t|
      t.string :description

      t.timestamps
    end
  end
end
