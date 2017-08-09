# -*- encoding: utf-8 -*-
# stub: pickles 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pickles".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "TODO: Set to 'http://mygemserver.com'" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["vs".freeze]
  s.date = "2017-08-09"
  s.description = "Set of common everyday steps with shortcuts".freeze
  s.email = ["vshaveyko@gmail.com".freeze]
  s.files = [".gitignore".freeze, ".rspec".freeze, ".travis.yml".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "lib/cucumber/pickles.rb".freeze, "lib/cucumber/pickles/can_see_step.rb".freeze, "lib/cucumber/pickles/config.rb".freeze, "lib/cucumber/pickles/entered_values_step.rb".freeze, "lib/cucumber/pickles/errors/index_node_not_found.rb".freeze, "lib/cucumber/pickles/form_steps.rb".freeze, "lib/cucumber/pickles/helpers/extensions/chrome/.DS_Store".freeze, "lib/cucumber/pickles/helpers/extensions/chrome/compiled.crx.base64".freeze, "lib/cucumber/pickles/helpers/extensions/chrome/manifest.json".freeze, "lib/cucumber/pickles/helpers/extensions/chrome/src/.DS_Store".freeze, "lib/cucumber/pickles/helpers/extensions/chrome/src/inject/inject.js".freeze, "lib/cucumber/pickles/helpers/fill_in.rb".freeze, "lib/cucumber/pickles/helpers/input_label_lookup.rb".freeze, "lib/cucumber/pickles/helpers/node_text_lookup.rb".freeze, "lib/cucumber/pickles/helpers/waiter.rb".freeze, "lib/cucumber/pickles/helpers/xpath.rb".freeze, "lib/cucumber/pickles/location_steps.rb".freeze, "lib/cucumber/pickles/navigation_steps.rb".freeze, "lib/cucumber/pickles/steps.rb".freeze, "lib/cucumber/pickles/steps/attach.rb".freeze, "lib/cucumber/pickles/steps/check.rb".freeze, "lib/cucumber/pickles/steps/common.rb".freeze, "lib/cucumber/pickles/steps/fill_in_following.rb".freeze, "lib/cucumber/pickles/steps/focus_is_on.rb".freeze, "lib/cucumber/pickles/steps/input.rb".freeze, "lib/cucumber/pickles/steps/js_select.rb".freeze, "lib/cucumber/pickles/steps/select.rb".freeze, "lib/cucumber/pickles/version.rb".freeze, "lib/cucumber/pickles/within_transform.rb".freeze, "lib/pickles.rb".freeze, "pickles.gemspec".freeze, "spec/helpers/waiter_spec.rb".freeze, "spec/pickles_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://localhost:3000".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.10".freeze
  s.summary = "Cucumber\\capybara steps".freeze

  s.installed_by_version = "2.6.10" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capybara>.freeze, [">= 1.1.2"])
      s.add_runtime_dependency(%q<cucumber>.freeze, [">= 1.1.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rs>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<capybara>.freeze, [">= 1.1.2"])
      s.add_dependency(%q<cucumber>.freeze, [">= 1.1.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rs>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<capybara>.freeze, [">= 1.1.2"])
    s.add_dependency(%q<cucumber>.freeze, [">= 1.1.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rs>.freeze, ["~> 3.0"])
  end
end
