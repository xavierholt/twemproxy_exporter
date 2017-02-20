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
      expect(subject.curr_connections.value   twemproxy_labels).to eq(380)
      expect(subject.total_connections.value  twemproxy_labels).to eq(109710)
      expect(subject.uptime.value             twemproxy_labels).to eq(1749519)

      # Cluster Metrics
      expect(subject.client_connections.value cluster_labels).to eq(315)
      expect(subject.client_eof.value         cluster_labels).to eq(109307)
      expect(subject.client_err.value         cluster_labels).to eq(23)
      expect(subject.forward_error.value      cluster_labels).to eq(0)
      expect(subject.fragments.value          cluster_labels).to eq(0)
      expect(subject.server_ejects.value      cluster_labels).to eq(0)

      # Server Metrics
      (0..63).each do |server_id|
        server_labels = cluster_labels.merge({ server: "app_persistent_#{server_id.to_s.rjust(2, "0")}" })

        if server_id == 0
          expect(subject.in_queue.value           server_labels).to eq(0)
          expect(subject.in_queue_bytes.value     server_labels).to eq(0)
          expect(subject.out_queue.value          server_labels).to eq(0)
          expect(subject.out_queue_bytes.value    server_labels).to eq(0)
          expect(subject.request_bytes.value      server_labels).to eq(673319623)
          expect(subject.requests.value           server_labels).to eq(4611711)
          expect(subject.response_bytes.value     server_labels).to eq(35218731)
          expect(subject.responses.value          server_labels).to eq(4611711)
          expect(subject.server_connections.value server_labels).to eq(1)
          expect(subject.server_ejected_at.value  server_labels).to eq(0)
          expect(subject.server_eof.value         server_labels).to eq(0)
          expect(subject.server_err.value         server_labels).to eq(0)
          expect(subject.server_timedout.value    server_labels).to eq(0)
        else
          expect(subject.in_queue.value           server_labels).to be >= 0
          expect(subject.in_queue_bytes.value     server_labels).to be >= 0
          expect(subject.out_queue.value          server_labels).to be >= 0
          expect(subject.out_queue_bytes.value    server_labels).to be >= 0
          expect(subject.request_bytes.value      server_labels).to be >= 0
          expect(subject.requests.value           server_labels).to be >= 0
          expect(subject.response_bytes.value     server_labels).to be >= 0
          expect(subject.responses.value          server_labels).to be >= 0
          expect(subject.server_connections.value server_labels).to be >= 0
          expect(subject.server_ejected_at.value  server_labels).to be >= 0
          expect(subject.server_eof.value         server_labels).to be >= 0
          expect(subject.server_err.value         server_labels).to be >= 0
          expect(subject.server_timedout.value    server_labels).to be >= 0
        end
      end
    end
  end
end
