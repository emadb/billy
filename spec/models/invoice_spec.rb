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
      expect(@invoice.customer).not_to be_nil
    end
    it "number should be nil" do
      expect(@invoice.number).to be_nil
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
    it 'should set the correct date and due_date' do
      invoice = Invoice.create_new
      date = Date.new(Date.today.year, Date.today.month, 1) - 1
      invoice.activate
      expect(invoice.date).to eq(date.end_of_month)
      expect(invoice.due_date).to eq(date.end_of_month + 30)
    end
  end

  context 'is in late' do
    it 'should not be in late if the due_date has to came' do
      #invoice = invoices(:invoice1)
      invoice = Invoice.create_new
      invoice.due_date = DateTime.now + 10
      expect(invoice.is_in_late?).to be_false
    end

    it 'should be in late if the due_date has passed' do
      invoice = Invoice.create_new
      invoice.due_date = DateTime.now - 10
      expect(invoice.is_in_late?).to be_true
    end

    it 'should not be in late if the due_date has passed but is payed' do
      invoice = Invoice.create_new
      invoice.due_date = DateTime.now - 10
      invoice.is_payed = true
      expect(invoice.is_in_late?).to be_false
    end
  end
end