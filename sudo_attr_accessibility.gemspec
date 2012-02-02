# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sudo_attr_accessibility/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gert Goet"]
  gem.email         = ["gert@thinkcreate.nl"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "sudo_attr_accessibility"
  gem.require_paths = ["lib"]
  gem.version       = SudoAttrAccessibility::VERSION
end
