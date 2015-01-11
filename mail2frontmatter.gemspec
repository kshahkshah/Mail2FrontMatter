# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail2frontmatter/version'

Gem::Specification.new do |spec|
  spec.name          = "mail2frontmatter"
  spec.version       = Mail2FrontMatter::VERSION
  spec.authors       = ["Kunal Shah"]
  spec.email         = ["me@kunalashah.com"]
  spec.summary       = %q{Email-to-blog parser which creates YAML FrontMatter}
  spec.description   = spec.summary + %q{. Uses Mailman to poll an account. }
  spec.homepage      = "https://github.com/whistlerbrk/Mail2FrontMatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mailman"
  spec.add_dependency "activesupport"
  spec.add_dependency "dante"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
