# Setup bundler to avoid having to run bundle exec all the time.
require "rubygems"
require "bundler/setup"

require "rake/testtask"
require_relative "lib/us_address_client/version"

task :gem do
  system "gem build us_address_client.gemspec"
end

task publish: :gem do
  system "git tag -a v#{USAddressClient::VERSION} -m 'Tagging #{USAddressClient::VERSION}'"
  system "git push --tags"
  system "gem push us_address_client-#{USAddressClient::VERSION}.gem"
  system "rm us_address_client-#{USAddressClient::VERSION}.gem"
end

Rake::TestTask.new(:test) do |t|
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
  t.warning = false
end

task default: :test
