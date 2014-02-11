# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','comet','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'comet'
  s.version = Comet::VERSION
  s.author = 'Adam Sheehan'
  s.email = 'adam.sheehan@launchacademy.com'
  s.homepage = 'http://launchacademy.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Command-line interface for downloading and submitting code exercises.'
# Add your other files here if you make them
  s.files = %w(
bin/comet
lib/comet.rb
lib/comet/api.rb
lib/comet/challenge.rb
lib/comet/init.rb
lib/comet/version.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','comet.rdoc']
  s.rdoc_options << '--title' << 'comet' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'comet'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_runtime_dependency('gli','2.8.1')
end
