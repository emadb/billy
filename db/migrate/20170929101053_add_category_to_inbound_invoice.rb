class AddCategoryToInboundInvoice < ActiveRecord::Migration
  def change
    add_column :inbound_invoices, :inbound_invoice_category_id, :integer
  end
end
