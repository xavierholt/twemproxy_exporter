require_relative "../spec_helper"

describe TwemproxyExporter::Counter do
  before(:all) do
    registry = Prometheus::Client.registry
    @counter = TwemproxyExporter::Counter.new(registry, :test_total, "A test counter")
  end

  context "#count" do
    it "should only increase" do
      expect do
        @counter.count(5)
      end.to change { collector_value(@counter) }.by(5)

      expect(@counter.send(:instance_variable_get, :@last)).to equal(5)

      expect do
        @counter.count(4)
      end.to change { collector_value(@counter) }.by(4)

      expect(@counter.send(:instance_variable_get, :@last)).to equal(4)

      expect do
        @counter.count(6)
      end.to change { collector_value(@counter) }.by(2)

      expect(@counter.send(:instance_variable_get, :@last)).to equal(6)
    end
  end
end
