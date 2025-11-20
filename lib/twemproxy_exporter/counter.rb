module TwemproxyExporter
  class Counter
    def initialize(registry, name, desc)
      @counter = Prometheus::Client::Counter.new(name, desc)
      registry.register(@counter)
    end

    def count(value, labels = {})
      current = value(labels)
      if value >= current
        @counter.increment(labels, value - current)
      else
        @counter.increment(labels, value)
      end
    end

    def value(labels = {})
      @counter.get(labels)
    end
  end
end
