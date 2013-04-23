require "spec_helper"

describe Invoice do
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
end