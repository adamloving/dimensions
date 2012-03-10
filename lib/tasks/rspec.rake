require 'rspec/core/rake_task'

task :default => 'spec:unit'

namespace :spec do
  desc "Run unit specs"

  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/**/{*_spec.rb}'
  end

  desc "Run acceptance specs"
  RSpec::Core::RakeTask.new('acceptance') do |t|
    t.pattern = 'spec/acceptance/**/*_spec.rb'
  end
end
