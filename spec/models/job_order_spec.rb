require "spec_helper"

describe JobOrder do
  fixtures :job_orders, :job_order_activities, :user_activities

  context "new JobOrder" do
    before do
      @job_order = JobOrder.create_new
    end
    it "has two activities" do
      expect(@job_order.activities.size).to eq(2)
    end
    it "customer should not be nil" do
      expect(@job_order.customer).not_to be_nil
    end

    it 'price is nil. Should be nil' do
      @job_order.price = nil
      expect(@job_order.a_project?).to be_nil
    end

    it 'price is zero. Should be nil' do
      @job_order.price = 0
      expect(@job_order.a_project?).to be_nil
    end

    it 'price is not zero. Should not be nil' do
      @job_order.price = 10
      expect(@job_order.a_project?).not_to be_nil
    end
  end

  context 'using fixtures' do
    it 'should have 30 total_estimated_hours' do
      job_order = job_orders(:job_order_1)
      expect(job_order.total_estimated_hours).to eq(30)
    end
    it 'should have 12 total_executed_hours' do
      job_order = job_orders(:job_order_1)
      expect(job_order.total_executed_hours).to eq(12)
    end
    it 'should be 40 percent of total hours' do
      job_order = job_orders(:job_order_1)
      expect(job_order.percent).to eq(40)
    end
    it 'should have only 1 acvite_activities' do
      job_order = job_orders(:job_order_2)
      expect(job_order.active_activities.size).to eq(1)
    end
    it 'should not be in warning' do
      job_order = job_orders(:job_order_1)
      expect(job_order.warning?).to be_false
    end
    it 'should be in warning' do
      job_order = job_orders(:job_order_3)
      expect(job_order.warning?).to be_true
    end
  end
end