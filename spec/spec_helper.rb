$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "twemproxy_exporter"

module Helpers
  def collector_value(collector, labels = {})
    ivar = case collector
      when TwemproxyExporter::Counter then :@counter
      when TwemproxyExporter::Gauge then :@gauge
      else; raise "Unknown collector type: #{collector.type.name}"
    end
    collector.send(:instance_variable_get, ivar).get(labels)
  end
end

RSpec.configure do |c|
  c.include Helpers
end
