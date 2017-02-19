# coding: utf-8
require_relative 'lib/twemproxy_exporter/version'

Gem::Specification.new do |spec|
  spec.name          = "twemproxy_exporter"
  spec.version       = TwemproxyExporter::VERSION
  spec.authors       = ["xavierholt", "Andrew Tongen"]
  spec.email         = ["xavierholt@gmail.com"]

  spec.summary       = %q{A Prometheus exporter for Twemproxy / Nutcracker.}
  spec.description   = %q{A Prometheus exporter for Twemproxy / Nutcracker.}
  spec.homepage      = "https://github.com/xavierholt/twemproxy_exporter"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

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
  spec.add_runtime_dependency "rack", "~> 2.0.0"
end
