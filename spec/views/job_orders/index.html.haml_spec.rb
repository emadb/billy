require 'spec_helper'

describe "job_orders/index" do
  before(:each) do
    assign(:job_orders, [
      stub_model(JobOrder,
        :name => "Name",
        :customer_id => "",
        :notes => "",
        :hourly_rate => "9.99",
        :archived? => false
      ),
      stub_model(JobOrder,
        :name => "Name",
        :customer_id => "",
        :notes => "",
        :hourly_rate => "9.99",
        :archived? => false
      )
    ])
  end

  it "renders a list of job_orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
