require_relative "../spec_helper"

describe TwemproxyExporter::Gauge do
  before(:all) do
    registry = Prometheus::Client.registry
    @gauge = TwemproxyExporter::Gauge.new(registry, :test_value, "A test gauge")
  end

  context "#count" do
    it "should increase or decrease" do
      @gauge.count(0)
      expect(collector_value(@gauge)).to eq(0)

      expect do
        @gauge.count(5)
      end.to change { collector_value(@gauge) }.by(5)

      expect do
        @gauge.count(4)
      end.to change { collector_value(@gauge) }.by(-1)

      expect do
        @gauge.count(6)
      end.to change { collector_value(@gauge) }.by(2)
    end
  end
end
