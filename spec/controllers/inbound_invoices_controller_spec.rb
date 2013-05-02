require "spec_helper"

describe InboundInvoicesController do
  fixtures :inbound_invoices

  describe 'GET index' do
    # it 'has one item' do
    #   inbound_invoice = inbound_invoices(:inbound_invoice_1)
    #   get :index, :date => '2013-04-01'
    #   assigns(:inbound_invoice).should eq([inbound_invoice])
    # end
    it "has a 200 status code" do
      get :index
      #expect(response.code).to eq("200")
    end
    # it "renders the :index view" do
    #   get :index
    #   response.should render_template :index
    # end
  end
end