require 'spec_helper'

describe "job_orders/new" do
  before(:each) do
    assign(:job_order, stub_model(JobOrder,
      :name => "MyString",
      :customer_id => "",
      :notes => "",
      :hourly_rate => "9.99",
      :archived? => false
    ).as_new_record)
  end

  it "renders new job_order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => job_orders_path, :method => "post" do
      assert_select "input#job_order_name", :name => "job_order[name]"
      assert_select "input#job_order_customer_id", :name => "job_order[customer_id]"
      assert_select "input#job_order_notes", :name => "job_order[notes]"
      assert_select "input#job_order_hourly_rate", :name => "job_order[hourly_rate]"
      assert_select "input#job_order_archived?", :name => "job_order[archived?]"
    end
  end
end
