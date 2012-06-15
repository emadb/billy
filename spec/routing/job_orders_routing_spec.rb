require "spec_helper"

describe JobOrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/job_orders").should route_to("job_orders#index")
    end

    it "routes to #new" do
      get("/job_orders/new").should route_to("job_orders#new")
    end

    it "routes to #show" do
      get("/job_orders/1").should route_to("job_orders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/job_orders/1/edit").should route_to("job_orders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/job_orders").should route_to("job_orders#create")
    end

    it "routes to #update" do
      put("/job_orders/1").should route_to("job_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/job_orders/1").should route_to("job_orders#destroy", :id => "1")
    end

  end
end
