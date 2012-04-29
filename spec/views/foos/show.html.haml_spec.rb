require 'spec_helper'

describe "foos/show" do
  before(:each) do
    @foo = assign(:foo, stub_model(Foo,
      :name => "Name",
      :published => false,
      :customer_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/false/)
    rendered.should match(/1/)
  end
end
