require "spec_helper"

describe InboundInvoicesController do
  fixtures :inbound_invoices, :users
  
  before do
    sign_in users(:admin)
  end

  describe 'GET index' do
    it 'has one item' do
      inbound_invoice = inbound_invoices(:inbound_invoice_1)
      get :index, :date => {:year => '2013', :month => '04', :day =>'01'}
      assigns(:invoices).should eq([inbound_invoice])
    end
    it "has a 200 status code" do
      get :index
      expect(response.code).to eq("200")
    end
    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end
  
  describe 'GET new' do
    it 'should set the current date' do
      get :new
      invoice = assigns(:invoice)
      expect(invoice.date).to eq(Date.today)
    end
  end

  # describe 'POST create' do
  #   it 'should redirect to the index' do
  #     post :create, :inbound_invoice => {:number => '42', :customer => 'test', :total => 100}
  #     InboundInvoice.should_receive(:new) #.with(:number => 42, :customer => 'test', :total => 100)
  #   end
  # end
end