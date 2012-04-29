require 'spec_helper'

describe "foos/edit" do
  before(:each) do
    @foo = assign(:foo, stub_model(Foo,
      :name => "MyString",
      :published => false,
      :customer_id => 1
    ))
  end

  it "renders the edit foo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => foos_path(@foo), :method => "post" do
      assert_select "input#foo_name", :name => "foo[name]"
      assert_select "input#foo_published", :name => "foo[published]"
      assert_select "input#foo_customer_id", :name => "foo[customer_id]"
    end
  end
end
