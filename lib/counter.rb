class Counter
  def initialize(registry, name, desc)
    @counter = Prometheus::Client::Counter.new(name, desc)
    registry.register(@counter)
    @last = 0
  end

  def count(value, labels = {})
    if value >= @last
      @counter.increment(labels, value - @last)
    else
      @counter.increment(labels, value)
    end

    @last = value
  end
end
