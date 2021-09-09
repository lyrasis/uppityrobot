# frozen_string_literal: true

require_relative "lib/uppityrobot/version"

Gem::Specification.new do |spec|
  spec.name          = "uppityrobot"
  spec.version       = UppityRobot::VERSION
  spec.authors       = ["Mark Cooper"]
  spec.email         = ["mark.c.cooper@outlook.com"]

  spec.summary       = "Command line wrapper for the UptimeRobot API (wrapper)."
  spec.description   = "Command line wrapper for the UptimeRobot API (wrapper)."
  spec.homepage      = "https://github.com/mark-cooper/uppityrobot.git"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-cli", "~> 0.7"
  spec.add_dependency "json", "~> 2.5"
  spec.add_dependency "uptimerobot", "~> 0.2"

  spec.add_development_dependency "aruba"
  spec.add_development_dependency "capybara_discoball"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "json_spec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "webmock"
end
