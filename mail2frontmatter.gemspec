# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail2frontmatter/version'

Gem::Specification.new do |spec|
  spec.name          = 'mail2frontmatter'
  spec.version       = Mail2FrontMatter::VERSION
  spec.authors       = ['Kunal Shah']
  spec.email         = ['me@kunalashah.com']
  spec.summary       = 'Email-to-blog parser which creates YAML FrontMatter'
  spec.description   = spec.summary + '. Uses Mailman to poll an account. '
  spec.homepage      = 'https://github.com/whistlerbrk/Mail2FrontMatter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mailman', '~> 0.7'
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'activesupport', '~> 4'
  spec.add_dependency 'rugged', '~> 0.21'
  spec.add_dependency 'rbtrace'

  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'byebug', '~> 3.5' unless RUBY_VERSION =~ /1.9/
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
