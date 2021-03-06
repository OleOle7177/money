# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'money/version'

Gem::Specification.new do |spec|
  spec.name          = "money"
  spec.version       = Money::VERSION
  spec.authors       = ["OleOle7177"]
  spec.email         = ["ole_@bk.ru"]
  spec.summary       = %q{Гем для конвертации курсов валют}
  spec.description   = %q{Гем использует данные ЦБ РФ}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency "nokogiri"
end
