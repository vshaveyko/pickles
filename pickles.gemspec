# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cucumber/pickles/version'

Gem::Specification.new do |s|
  s.name          = "pickles"
  s.version       = Pickles::VERSION
  s.authors       = ["vs"]
  s.email         = ["vshaveyko@gmail.com"]

  s.summary       = %q{Cucumber\capybara steps}
  s.description   = %q{Set of common everyday steps with shortcuts}
  s.homepage      = "http://localhost:3000"
  s.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|s|features)/}) }
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }

  s.add_dependency 'capybara', '>= 1.1.2'
  s.add_dependency 'cucumber', '>= 1.1.1'

  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rs", "~> 3.0"
end
