require "spec_helper"

describe FoosController do
  describe "routing" do

    it "routes to #index" do
      get("/foos").should route_to("foos#index")
    end

    it "routes to #new" do
      get("/foos/new").should route_to("foos#new")
    end

    it "routes to #show" do
      get("/foos/1").should route_to("foos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/foos/1/edit").should route_to("foos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/foos").should route_to("foos#create")
    end

    it "routes to #update" do
      put("/foos/1").should route_to("foos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/foos/1").should route_to("foos#destroy", :id => "1")
    end

  end
end
