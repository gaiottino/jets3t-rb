require 'rspec/core/rake_task'

default_rspec_opts = %w[-r ./spec/spec_helper.rb --colour --format Fuubar]

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = default_rspec_opts
  t.pattern = 'spec/**/*_spec.rb'
end
