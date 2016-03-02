require 'yaml'
require 'socket'

class Twemproxy
  attr_reader :host
  attr_reader :port
  attr_reader :registry

  def initialize(registry, host = 'localhost', port = 22222)
    @registry = registry
    @host     = host
    @port     = port
  end

  def count
    stats  = self.stats
    name   = stats['source']
    labels = {twemproxy: name}

    @registry.total_connections.count stats['total_connections'], labels
    @registry.curr_connections.count  stats['curr_connections'],  labels
    @registry.uptime.count            stats['uptime'],            labels

    stats.each do |cluster, cinfo|
      next unless cinfo.is_a? Hash
      labels = {twemproxy: name, cluster: cluster}

      @registry.fragments.count          cinfo['fragments'],          labels
      @registry.forward_error.count      cinfo['forward_error'],      labels
      @registry.server_ejects.count      cinfo['server_ejects'],      labels
      @registry.client_connections.count cinfo['client_connections'], labels
      @registry.client_err.count         cinfo['client_err'],         labels
      @registry.client_eof.count         cinfo['client_eof'],         labels

      cinfo.each do |server, sinfo|
        next unless sinfo.is_a? Hash
        labels = {twemproxy: name, cluster: cluster, server: server}

        @registry.in_queue.count           sinfo['in_queue'],           labels
        @registry.in_queue_bytes.count     sinfo['in_queue_bytes'],     labels
        @registry.out_queue.count          sinfo['out_queue'],          labels
        @registry.out_queue_bytes.count    sinfo['out_queue_bytes'],    labels
        @registry.request_bytes.count      sinfo['request_bytes'],      labels
        @registry.requests.count           sinfo['requests'],           labels
        @registry.response_bytes.count     sinfo['response_bytes'],     labels
        @registry.responses.count          sinfo['responses'],          labels
        @registry.server_connections.count sinfo['server_connections'], labels
        @registry.server_ejected_at.count  sinfo['server_ejected_at'],  labels
        @registry.server_eof.count         sinfo['server_eof'],         labels
        @registry.server_err.count         sinfo['server_err'],         labels
        @registry.server_timedout.count    sinfo['server_timedout'],    labels
      end
    end
  end

  def stats
    socket = TCPSocket.new(@host, @port)
    return YAML.load(socket.read)
  ensure
    socket.close
  end
end
