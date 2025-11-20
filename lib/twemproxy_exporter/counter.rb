module TwemproxyExporter
  class Counter
    def initialize(registry, name, desc)
      @counter = Prometheus::Client::Counter.new(name, desc)
      registry.register(@counter)
      @last_values = {}
    end

    def count(value, labels = {})
      last = @last_values[labels] || 0
      if value >= last
        @counter.increment(labels, value - last)
      else
        @counter.increment(labels, value)
      end
      @last_values[labels] = value
    end

    def value(labels = {})
      @counter.get(labels)
    end
  end
end
