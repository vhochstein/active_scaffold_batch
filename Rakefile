require 'rake'
# require 'bundler'
# begin
#   Bundler.setup(:default, :development)
# rescue Bundler::BundlerError => e
#   $stderr.puts e.message
#   $stderr.puts "Run `bundle install` to install missing gems"
#   exit e.status_code
# end
require 'rake'

require 'jeweler'
require './lib/active_scaffold_batch/version.rb'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "active_scaffold_batch"
  gem.version = ActiveScaffoldBatch::Version::STRING
  gem.homepage = "http://github.com/vhochstein/active_scaffold_batch"
  gem.license = "MIT"
  gem.summary = %Q{Batch Processing for ActiveScaffold}
  gem.description = %Q{You want to destroy/update many records at once with activescaffold?}
  gem.email = "activescaffold@googlegroups.com"
  gem.authors = ["Volker Hochstein"]
  # gem.add_runtime_dependency 'active_scaffold', '>= 3.1'
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "active_scaffold_batch #{ActiveScaffoldBatch::Version::STRING}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
