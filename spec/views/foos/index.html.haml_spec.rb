require 'spec_helper'

describe "foos/index" do
  before(:each) do
    assign(:foos, [
      stub_model(Foo,
        :name => "Name",
        :published => false,
        :customer_id => 1
      ),
      stub_model(Foo,
        :name => "Name",
        :published => false,
        :customer_id => 1
      )
    ])
  end

  it "renders a list of foos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
