# coding: utf-8
require File.expand_path('../lib/slack-rtm-api/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name                   = 'slack-rtm-api'
  spec.version                = SlackRTMApi::VERSION
  spec.authors                = ['Rémi Delhaye']
  spec.email                  = ['contact@rdlh.io']
  spec.summary                = 'A simple Slack RTM API Client'
  spec.description            = 'A simple Slack RTM API Client'
  spec.homepage               = 'https://github.com/rdlh/slack-rtm-api'
  spec.license                = 'MIT'
  spec.required_ruby_version  = '~> 2.0'

  spec.files                  = `git ls-files -z`.split("\x0")
  spec.executables            = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files             = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths          = ['lib']

  dev_dep = %w(
    bundler
    rake
    colored
  )

  run_dep = %w(
    websocket-driver
  )

  dev_dep.each { |d| spec.add_development_dependency d }
  run_dep.each { |d| spec.add_runtime_dependency d }
end
