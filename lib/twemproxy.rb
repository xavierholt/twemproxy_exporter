require 'yaml'
require 'socket'

class Twemproxy
  attr_reader :exporter
  attr_reader :host
  attr_reader :port

  def initialize(exporter, host = 'localhost', port = 22222)
    @exporter = exporter
    @host     = host
    @port     = port
  end

  def count
    stats  = self.stats
    name   = stats['source']
    labels = {twemproxy: name}

    @exporter.total_connections.count stats['total_connections'], labels
    @exporter.curr_connections.count  stats['curr_connections'],  labels
    @exporter.uptime.count            stats['uptime'],            labels

    stats.each do |cluster, cinfo|
      next unless cinfo.is_a? Hash
      labels = {twemproxy: name, cluster: cluster}

      @exporter.fragments.count          cinfo['fragments'],          labels
      @exporter.forward_error.count      cinfo['forward_error'],      labels
      @exporter.server_ejects.count      cinfo['server_ejects'],      labels
      @exporter.client_connections.count cinfo['client_connections'], labels
      @exporter.client_err.count         cinfo['client_err'],         labels
      @exporter.client_eof.count         cinfo['client_eof'],         labels

      cinfo.each do |server, sinfo|
        next unless sinfo.is_a? Hash
        labels = {twemproxy: name, cluster: cluster, server: server}

        @exporter.in_queue.count           sinfo['in_queue'],           labels
        @exporter.in_queue_bytes.count     sinfo['in_queue_bytes'],     labels
        @exporter.out_queue.count          sinfo['out_queue'],          labels
        @exporter.out_queue_bytes.count    sinfo['out_queue_bytes'],    labels
        @exporter.request_bytes.count      sinfo['request_bytes'],      labels
        @exporter.requests.count           sinfo['requests'],           labels
        @exporter.response_bytes.count     sinfo['response_bytes'],     labels
        @exporter.responses.count          sinfo['responses'],          labels
        @exporter.server_connections.count sinfo['server_connections'], labels
        @exporter.server_ejected_at.count  sinfo['server_ejected_at'],  labels
        @exporter.server_eof.count         sinfo['server_eof'],         labels
        @exporter.server_err.count         sinfo['server_err'],         labels
        @exporter.server_timedout.count    sinfo['server_timedout'],    labels
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
