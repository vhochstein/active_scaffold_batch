# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'active_scaffold_batch/version'

Gem::Specification.new do |s|
  s.name = %q{active_scaffold_batch_vho}
  s.version = ActiveScaffoldBatch::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.authors = ["Volker Hochstein"]
  s.summary = %q{Batch Processing for ActiveScaffold}
  s.description = %q{You want to batch create/destroy/update many records at once with activescaffold?}
  s.email = %q{vhochstein@gmail.com}
  s.extra_rdoc_files = [
      "README"
  ]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.homepage = %q{http://github.com/vhochstein/active_scaffold_batch}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
  s.add_development_dependency(%q<simplecov>, ["~> 0.9.0"])

  s.add_runtime_dependency(%q<active_scaffold_vho>, [">= 3.1.2"])
end