# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twemproxy_exporter/version'

Gem::Specification.new do |spec|
  spec.name          = "twemproxy_exporter"
  spec.version       = TwemproxyExporter::VERSION
  spec.licenses      = ["Apache-2.0"]

  spec.summary       = "A Prometheus exporter for Twemproxy / Nutcracker."
  spec.homepage      = "https://github.com/xavierholt/twemproxy_exporter"
  spec.authors       = ["Kevin Burk", "Andrew Tongen"]
  spec.email         = ["xavierholt@gmail.com"]


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "prometheus-client", "~> 0.6.0"
  spec.add_runtime_dependency "rack", "~> 2.0"
end
