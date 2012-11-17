# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chef-recipe/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bryan Berry"]
  gem.email         = ["bryan.berry@gmail.com"]
  gem.description   = %q{command to execute a single chef recipe}
  gem.summary       = %q{This gem installs a command that can be used to execute a single chef recipe}
  gem.homepage      = "https://github.com/bryanwb/chef-recipe"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "chef-recipe"
  gem.require_paths = ["lib"]
  gem.version       = Chef::Recipe::VERSION
end
