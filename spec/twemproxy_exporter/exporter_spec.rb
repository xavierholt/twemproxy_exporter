require "spec_helper"

describe TwemproxyExporter::Exporter do
  let(:stats_file) { File.open("spec/fixtures/files/stats.json") }
  let(:config) { { "proxies" => ["localhost"] } }
  let(:twemproxy_labels) { { twemproxy: "app-production-redis-twemproxy" } }
  let(:cluster_labels) { twemproxy_labels.merge({ cluster: "app_persistent" }) }

  before do
    expect(TCPSocket).to receive(:new).and_return(stats_file)
  end

  subject { TwemproxyExporter::Exporter.new(config) }

  context "proxies" do
    it "should count stats" do
      subject.proxies.each(&:count)

      # Twemproxy Metrics
      expect(collector_value(subject.curr_connections, twemproxy_labels)).to eq(380)
      expect(collector_value(subject.total_connections, twemproxy_labels)).to eq(109710)
      expect(collector_value(subject.uptime, twemproxy_labels)).to eq(1749519)

      # Cluster Metrics
      expect(collector_value(subject.client_connections, cluster_labels)).to eq(315)
      expect(collector_value(subject.client_eof, cluster_labels)).to eq(109307)
      expect(collector_value(subject.client_err, cluster_labels)).to eq(23)
      expect(collector_value(subject.forward_error, cluster_labels)).to eq(0)
      expect(collector_value(subject.fragments, cluster_labels)).to eq(0)
      expect(collector_value(subject.server_ejects, cluster_labels)).to eq(0)

      # Server Metrics
      (0..63).each do |server_id|
        server_labels = cluster_labels.merge({ server: "app_persistent_#{server_id.to_s.rjust(2, "0")}" })

        if server_id == 0
          expect(collector_value(subject.in_queue, server_labels)).to eq(0)
          expect(collector_value(subject.in_queue_bytes, server_labels)).to eq(0)
          expect(collector_value(subject.out_queue, server_labels)).to eq(0)
          expect(collector_value(subject.out_queue_bytes, server_labels)).to eq(0)
          expect(collector_value(subject.request_bytes, server_labels)).to eq(673319623)
          expect(collector_value(subject.requests, server_labels)).to eq(4611711)
          expect(collector_value(subject.response_bytes, server_labels)).to eq(35218731)
          expect(collector_value(subject.responses, server_labels)).to eq(4611711)
          expect(collector_value(subject.server_connections, server_labels)).to eq(1)
          expect(collector_value(subject.server_ejected_at, server_labels)).to eq(0)
          expect(collector_value(subject.server_eof, server_labels)).to eq(0)
          expect(collector_value(subject.server_err, server_labels)).to eq(0)
          expect(collector_value(subject.server_timedout, server_labels)).to eq(0)
        else
          expect(collector_value(subject.in_queue, server_labels)).to be >= 0
          expect(collector_value(subject.in_queue_bytes, server_labels)).to be >= 0
          expect(collector_value(subject.out_queue, server_labels)).to be >= 0
          expect(collector_value(subject.out_queue_bytes, server_labels)).to be >= 0
          expect(collector_value(subject.request_bytes, server_labels)).to be >= 0
          expect(collector_value(subject.requests, server_labels)).to be >= 0
          expect(collector_value(subject.response_bytes, server_labels)).to be >= 0
          expect(collector_value(subject.responses, server_labels)).to be >= 0
          expect(collector_value(subject.server_connections, server_labels)).to be >= 0
          expect(collector_value(subject.server_ejected_at, server_labels)).to be >= 0
          expect(collector_value(subject.server_eof, server_labels)).to be >= 0
          expect(collector_value(subject.server_err, server_labels)).to be >= 0
          expect(collector_value(subject.server_timedout, server_labels)).to be >= 0
        end
      end
    end
  end
end
