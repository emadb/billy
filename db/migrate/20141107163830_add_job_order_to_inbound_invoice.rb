class AddJobOrderToInboundInvoice < ActiveRecord::Migration
  def change
    add_column :inbound_invoices, :job_order_id, :integer
  end
end
