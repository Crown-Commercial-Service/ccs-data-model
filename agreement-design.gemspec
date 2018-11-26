# agreement-design.gemspec
# TODO - split the gem for schema design from the one containing agreement models
Gem::Specification.new do |spec|
  spec.name          = "ccs-data-model"
  spec.version       = "0.0.1"
  spec.authors       = ["CCS"]
  spec.homepage      = 'https://github.com/Crown-Commercial-Service/ccs-data-model'
  spec.email         = ["rubygems@humphries.tech"]
  spec.description   = %q{Alpha model of data interfaces for commercial agreements.}
  spec.summary       = %q{CCS Data alpha.}
  spec.license       = "MIT"

  spec.files         = Dir["./**/*"]
  spec.executables   = Dir["./bin/*"]
  spec.test_files    = Dir["./test/**/*"]
  spec.require_paths = ["src", "model"]

  spec.add_development_dependency "rake", "12.3.0"
end