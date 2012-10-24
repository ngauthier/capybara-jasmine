# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Nick Gauthier"]
  gem.email         = ["ngauthier@gmail.com"]
  gem.description   = %q{Run your jasmine.js tests with capybara}
  gem.homepage      = "http://github.com/ngauthier/capybara-jasmine"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capybara-jasmine"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
  gem.add_dependency 'capybara', '~> 1.0'
end
