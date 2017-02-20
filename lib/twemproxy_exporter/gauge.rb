module TwemproxyExporter
  class Gauge
    def initialize(registry, name, desc)
      @gauge = Prometheus::Client::Gauge.new(name, desc)
      registry.register(@gauge)
    end

    def count(value, labels = {})
      @gauge.set(labels, value)
    end

    def value(labels = {})
      @gauge.get(labels)
    end
  end
end
