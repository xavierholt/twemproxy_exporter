# twemproxy_exporter
[![Build Status](https://travis-ci.org/xavierholt/twemproxy_exporter.svg?branch=master)](https://travis-ci.org/xavierholt/twemproxy_exporter)
[![Gem Version](https://badge.fury.io/rb/twemproxy_exporter.svg)](https://rubygems.org/gems/twemproxy_exporter)

This is a simple Prometheus exporter for Twemproxy (a.k.a. Nutcracker), written
in Ruby.  It currently takes a list of Twemproxy URLs to monitor and exposes
metrics at http://localhost:9222/metrics

Run it from the command line like this:

```sh
twemproxy_exporter my.proxy.host my.other.proxy.host:33333
```

Run it with the `--help` flag to see the full list of options, or check out [the
source](https://github.com/xavierholt/twemproxy_exporter/blob/master/bin/twemproxy_exporter).
It can also read these options from a JSON or YAML file:

```yml
bind: 127.0.0.1
port: 9876
interval: 10
timeout: 2
proxies:
- my.twemproxy.host
- my.other.twemproxy.host:33333
```

```sh
twemproxy_exporter -f config.yml
```

Pull requests welcome!
