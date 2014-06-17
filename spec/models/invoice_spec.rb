require "spec_helper"

# TODO: There should be a better way
class FakeSettings
  def self.fiscal_year
    '2013'
  end
end


describe Invoice do
  AppSettings = FakeSettings
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

  context 'on existing invoice' do
    it 'should be able to clone' do
      invoice = Invoice.create_new
      invoice.customer = Customer.new 
      invoice.customer.id = 42
      invoice.due_date = DateTime.now - 10
      invoice.is_payed = true
      invoice.invoice_items[0].description = 'item one'
      invoice.invoice_items[1].description = 'item two' 
      invoice.taxable_income = 30
      invoice.activate

      new_invoice = invoice.clone
      expect(new_invoice.customer.id).to eq(42)
      expect(new_invoice.invoice_items[0].description).to eq('item one')
      expect(new_invoice.taxable_income).to eq(30)
    end
  end
end