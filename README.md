# twemproxy_exporter

This is a simple Prometheus exporter for Twemproxy (a.k.a. Nutcracker), written
in Ruby.  It currently takes two options: a check interval (optional; defaults
to 30 seconds) and a list of Twemproxy URLs to monitor (technically optional,
but nothing interesting's gonna happen without these).  It exposes metrics at
http://localhost:8080/metrics

Run it from the command line like this:

```sh
twemproxy_exporter -i 10 my.proxy.host my.other.proxy.host:33333
```

It can also read these options from a JSON or YAML file:

```yml
interval: 10
proxies:
  - my.proxy.host
  - my.other.proxy.host:33333
```

```sh
twemproxy_exporter -f config.yml
```

That's all it does for now.  Pull requests welcome!
