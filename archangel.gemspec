# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "archangel/version"

Gem::Specification.new do |spec|
  spec.name          = "archangel"
  spec.version       = Archangel::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ["James Smith"]
  spec.email         = ["james@floppy.org.uk"]

  spec.summary       = %q{A client library and command-line interface for the Archangel DLT system.}
  spec.homepage      = "https://archangel.ac.uk"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
