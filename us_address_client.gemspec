$:.push File.expand_path("lib", __dir__)

require "us_address_client/version"

Gem::Specification.new do |s|
  s.name                  = "us_address_client"
  s.version               = USAddressClient::VERSION
  s.authors               = ["Reid Morrison"]
  s.summary               = "US Address Service Client"
  s.homepage              = "https://github.com/reidmorrison/us_address_client"
  s.description           = "US Address Client that calls the privately hosted US Address Service that calls Melissa Data Address Object"
  s.files                 = Dir["lib/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files            = Dir["test/**/*"]
  s.license               = "Apache-2.0"
  s.required_ruby_version = ">= 2.5"

  s.add_dependency "opinionated_http", "~> 0.1"
  s.add_dependency "secret_config"
  s.add_dependency "sync_attr"
end
