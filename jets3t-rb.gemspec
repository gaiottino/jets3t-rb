# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

Dir['ext/*.jar'].each { |jar| require jar }


Gem::Specification.new do |s|
  s.name        = 'jets3t-rb'
  s.version     = '1.0.4'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Daniel Gaiottino', 'David Tollmyr']
  s.email       = ['daniel@burtcorp.com', 'david@burtcorp.com']
  s.homepage    = 'http://github.com/gaiottino/jets3t-rb'
  s.summary     = %q{JRuby wrapper for JetS3t}
  s.description = %q{JRuby wrapper for JetS3t (http://jets3t.s3.amazonaws.com/)}

  s.rubyforge_project = 'jets3t-rb'

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)

  s.add_development_dependency  'awesome_print',      '~> 1.0.2'
  s.add_development_dependency  'fuubar',             '~> 1.0.0'
  s.add_development_dependency  'rspec',              '~> 2.8.0'
end
