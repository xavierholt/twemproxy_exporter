describe TwemproxyExporter::Counter do
  context "#count" do
    context "without labels" do
      before(:all) do
        registry = Prometheus::Client.registry
        @counter = TwemproxyExporter::Counter.new(registry, :test_total, "A test counter")
      end

      it "should only increase" do
        expect do
          @counter.count(5)
        end.to change { @counter.value }.by(5)

        expect do
          @counter.count(5)
        end.to change { @counter.value }.by(0)

        expect do
          @counter.count(0)
        end.to change { @counter.value }.by(0)

        expect do
          @counter.count(6)
        end.to change { @counter.value }.by(1)

        expect do
          @counter.count(10)
        end.to change { @counter.value }.by(4)

        @counter.value.should eq(10)
      end
    end

    context "with labels" do
      before(:all) do
        registry = Prometheus::Client.registry
        @counter = TwemproxyExporter::Counter.new(registry, :test_with_labels_total, "A test counter with labels")
      end

      it "should handle multiple labels independently" do
        label_a = { server: 'A' }
        label_b = { server: 'B' }

        expect do
          @counter.count(0, label_a)
        end.to change { @counter.value(label_a) }.by(0)
        expect do 
          @counter.count(10, label_b)
        end.to change { @counter.value(label_b) }.by(10)

        # no change
        expect do
          @counter.count(0, label_a)
        end.to change { @counter.value(label_a) }.by(0)
        expect do 
          @counter.count(10, label_b)
        end.to change { @counter.value(label_b) }.by(0)

        # label_b increases
        expect do
          @counter.count(0, label_a)
        end.to change { @counter.value(label_a) }.by(0)
        expect do 
          @counter.count(15, label_b)
        end.to change { @counter.value(label_b) }.by(5)

        # final check of absolute values
        @counter.value(label_a).should eq(0)
        @counter.value(label_b).should eq(15)
      end
    end
  end
end
