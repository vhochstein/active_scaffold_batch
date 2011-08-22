# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_scaffold_batch_vho}
  s.version = "3.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Volker Hochstein"]
  s.date = %q{2011-03-14}
  s.description = %q{You want to destroy/update many records at once with activescaffold?}
  s.email = %q{activescaffold@googlegroups.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README"
  ]
  s.files = [
    ".document",
    "LICENSE.txt",
    "README",
    "Rakefile",
    "active_scaffold_batch_vho.gemspec",
    "frontends/default/views/_batch_create_form.html.erb",
    "frontends/default/views/_batch_create_form_attribute.html.erb",
    "frontends/default/views/_batch_create_form_body.html.erb",
    "frontends/default/views/_batch_update_form.html.erb",
    "frontends/default/views/_batch_update_form_attribute.html.erb",
    "frontends/default/views/_batch_update_form_attribute_scope.html.erb",
    "frontends/default/views/_batch_update_form_body.html.erb",
    "frontends/default/views/batch_create.html.erb",
    "frontends/default/views/batch_update.html.erb",
    "frontends/default/views/on_batch_base.js.rjs",
    "frontends/default/views/on_batch_create.js.rjs",
    "frontends/default/views/on_batch_update.js.rjs",
    "init.rb",
    "lib/active_scaffold/actions/batch_base.rb",
    "lib/active_scaffold/actions/batch_create.rb",
    "lib/active_scaffold/actions/batch_destroy.rb",
    "lib/active_scaffold/actions/batch_update.rb",
    "lib/active_scaffold/config/batch_base.rb",
    "lib/active_scaffold/config/batch_create.rb",
    "lib/active_scaffold/config/batch_destroy.rb",
    "lib/active_scaffold/config/batch_update.rb",
    "lib/active_scaffold/helpers/batch_create_column_helpers.rb",
    "lib/active_scaffold/helpers/calendar_date_select_update_column_helpers.rb",
    "lib/active_scaffold/helpers/datepicker_update_column_helpers.rb",
    "lib/active_scaffold/helpers/update_column_helpers.rb",
    "lib/active_scaffold_batch.rb",
    "lib/active_scaffold_batch/config/core.rb",
    "lib/active_scaffold_batch/locale/de.yml",
    "lib/active_scaffold_batch/locale/en.yml",
    "lib/active_scaffold_batch/version.rb",
    "lib/active_scaffold_batch_vho.rb",
    "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/vhochstein/active_scaffold_batch}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Batch Processing for ActiveScaffold}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_runtime_dependency(%q<active_scaffold>, ["> 3.0.13"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<active_scaffold>, ["> 3.0.13"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<active_scaffold>, ["> 3.0.13"])
  end
end

