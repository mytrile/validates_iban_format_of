$:.unshift File.expand_path('../lib', __FILE__)
require 'validates_iban_format_of/version'

spec = Gem::Specification.new do |s|
  s.name          = 'validates_iban_format_of'
  s.version       = ValidatesIbanFormatOf::VERSION
  s.summary       = 'Validate iban'
  s.description   = s.summary
  s.authors       = ['Dimitar Kostov']
  s.email         = ['mitko.kostov@gmail.com']
  s.homepage      = 'https://github.com/mytrile/validates_iban_format_of'
  s.license       = 'MIT'
  s.test_files    = s.files.grep(%r{^spec/})
  s.files         = `git ls-files`.split($/)
  s.require_paths = ['lib']

  s.add_dependency 'i18n', '~> 0.7'
  s.add_dependency 'activesupport', '~> 4.2'
  s.add_dependency 'iban-tools', '~> 1.1'
  s.add_development_dependency 'bundler', '~> 1.13'
  s.add_development_dependency 'rspec', '~> 3.6'
end
