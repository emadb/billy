require "spec_helper"

describe Invoice do
  fixtures :invoices

  context "new invoice" do
    before do
      @invoice = Invoice.create_new
    end
    it "has two items" do
      expect(@invoice.invoice_items.size).to eq(2)
    end
    it "customer should not be nil" do
      @invoice.customer.should_not be_nil
    end
    it "number should be nil" do
      @invoice.number.should be_nil
    end
  end
  
  context 'invoice to activate' do
    it 'should set the correct invoice number' do
      invoice = Invoice.create_new
      invoice.activate
      expect(invoice.number).to eq(3)
    end
    it 'should set the correct state' do
      invoice = Invoice.create_new
      invoice.activate
      expect(invoice.status).to eq(Invoice.active)
    end
  end
end