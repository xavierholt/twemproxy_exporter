require 'prometheus/client'

require_relative 'gauge'
require_relative 'counter'
require_relative 'twemproxy'

class Exporter
  attr_reader :proxies
  attr_reader :registry

  # Twemproxy Metrics
  attr_reader :curr_connections
  attr_reader :total_connections
  attr_reader :uptime

  # Cluster Metrics
  attr_reader :client_connections
  attr_reader :client_eof
  attr_reader :client_err
  attr_reader :forward_error
  attr_reader :fragments
  attr_reader :server_ejects

  # Server Metrics
  attr_reader :in_queue
  attr_reader :in_queue_bytes
  attr_reader :out_queue
  attr_reader :out_queue_bytes
  attr_reader :request_bytes
  attr_reader :requests
  attr_reader :response_bytes
  attr_reader :responses
  attr_reader :server_connections
  attr_reader :server_ejected_at
  attr_reader :server_eof
  attr_reader :server_err
  attr_reader :server_timedout

  
  def initialize(config)
    @running  = true
    @registry = Prometheus::Client.registry
    @interval = config[:interval] || 30
    @proxies  = config[:proxies].map do |arg|
      host, port = arg.split(':')
      Twemproxy.new(self, host, port || 22222)
    end

    # Twemproxy Metrics
    @curr_connections   = Gauge.new   @registry, :twemproxy_curr_connections,   'Current Connections'
    @total_connections  = Counter.new @registry, :twemproxy_total_connections,  'Total Connections'
    @uptime             = Gauge.new   @registry, :twemproxy_uptime,             'Current Uptime'

    # Cluster Metrics
    @client_connections = Counter.new @registry, :twemproxy_client_connections, 'Client Connections'
    @client_eof         = Counter.new @registry, :twemproxy_client_eof,         'Client EOFs'
    @client_err         = Counter.new @registry, :twemproxy_client_err,         'Client Errors'
    @forward_error      = Counter.new @registry, :twemproxy_forward_error,      'Forwarding Errors'
    @fragments          = Counter.new @registry, :twemproxy_fragments,          'Fragments'
    @server_ejects      = Counter.new @registry, :twemproxy_server_ejects,      'Server Errors'

    # Server Metrics
    @in_queue           = Gauge.new   @registry, :twemproxy_in_queue,           'In Queue Depth'
    @in_queue_bytes     = Gauge.new   @registry, :twemproxy_in_queue_bytes,     'In Queue Bytes'
    @out_queue          = Gauge.new   @registry, :twemproxy_out_queue,          'Out Queue Depth'
    @out_queue_bytes    = Gauge.new   @registry, :twemproxy_out_queue_bytes,    'Out Queue Bytes'
    @request_bytes      = Counter.new @registry, :twemproxy_request_bytes,      'Request Bytes'
    @requests           = Counter.new @registry, :twemproxy_requests,           'Request Count'
    @response_bytes     = Counter.new @registry, :twemproxy_response_bytes,     'Response Bytes'
    @responses          = Counter.new @registry, :twemproxy_responses,          'Response Count'
    @server_connections = Counter.new @registry, :twemproxy_server_connections, 'Server Connections'
    @server_ejected_at  = Gauge.new   @registry, :twemproxy_server_ejected_at,  'Server Ejected At'
    @server_eof         = Counter.new @registry, :twemproxy_server_eof,         'Server EOFs'
    @server_err         = Counter.new @registry, :twemproxy_server_err,         'Server Errors'
    @server_timedout    = Gauge.new   @registry, :twemproxy_server_timedout,    'Server Timed Out'
  end

  def run!
    while @running
      threads = @proxies.map do |proxy|
        Thread.new {proxy.count}
      end

      threads.each do |thread|
        thread.join
      end

      self.sleep
    end
  end

  def stop!
    @running = false
  end

protected
  def sleep
    @interval.times do |i|
      break unless @running
      Kernel.sleep 1
    end
  end
end
