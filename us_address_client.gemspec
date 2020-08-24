$:.push File.expand_path('lib', __dir__)

require 'us_address_client/version'

Gem::Specification.new do |s|
  s.name        = 'us_address_client'
  s.version     = USAddressClient::VERSION
  s.authors     = ['itstaff']
  s.email       = ['itstaff@clarityservices.com']

  s.summary     = 'Postal Address Service Client'
  s.description = 'Client to call the Clarity internal Postal Address Service to verify and cleanse addresses'

  s.files      = Dir['lib/**/*', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'activesupport'
  s.add_dependency 'opinionated_http'
  s.add_dependency 'secret_config'
  s.add_dependency 'semantic_logger'
  s.add_dependency 'sync_attr'
  # Temporary dependency until melissa is no longer local at all
  s.add_dependency 'melissa', '0.0.9.beta.2'
end
