require 'spec_helper'

describe "job_orders/show" do
  before(:each) do
    @job_order = assign(:job_order, stub_model(JobOrder,
      :name => "Name",
      :customer_id => "",
      :notes => "",
      :hourly_rate => "9.99",
      :archived? => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/9.99/)
    rendered.should match(/false/)
  end
end
