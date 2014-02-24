# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','comet','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'comet'
  s.version = Comet::VERSION
  s.author = 'Adam Sheehan'
  s.email = 'adam.sheehan@launchacademy.com'
  s.license = 'MIT'
  s.homepage = 'http://www.launchacademy.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Command-line interface for downloading and submitting code exercises.'
  s.description = 'Command-line interface to download various code exercises and their test suites. When the tests are all passing submit your solution for grading.'
# Add your other files here if you make them
  s.files = %w(
bin/comet
lib/comet.rb
lib/comet/api.rb
lib/comet/challenge.rb
lib/comet/init.rb
lib/comet/version.rb
lib/helpers.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','comet.rdoc']
  s.rdoc_options << '--title' << 'comet' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'comet'
  s.add_development_dependency('rake', '~> 0')
  s.add_development_dependency('rdoc', '~> 0')
  s.add_development_dependency('rspec', '~> 0')
  s.add_runtime_dependency('gli','2.8.1')
  s.add_runtime_dependency('rest-client', '~> 1.6')
end
