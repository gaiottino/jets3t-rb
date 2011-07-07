# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

require 'jets3t/version'

Dir['ext/*.jar'].each { |jar| require jar }


Gem::Specification.new do |s|
  s.name        = 'jets3t-rb'
  s.version     = JetS3t::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Daniel Gaiottino']
  s.email       = ['daniel@burtcorp.com']
  s.homepage    = 'http://github.com/gaiottino/jets3t-rb'
  s.summary     = %q{JRuby wrapper for JetS3t}
  s.description = %q{JRuby wrapper for JetS3t}

  s.rubyforge_project = 'jets3t-rb'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
