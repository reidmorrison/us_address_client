require 'us_address_client/version'
require 'opinionated_http'
require 'secret_config'
module USAddressClient
  autoload :Address, 'us_address_client/address'
  autoload :AddressMock, 'us_address_client/address_mock'
  autoload :Client, 'us_address_client/client'
  autoload :Parser, 'us_address_client/parser'
  autoload :ServiceError, 'us_address_client/service_error'

  include SemanticLogger::Loggable

  # Verify, and cleanse the address, also returning the delivery_point.
  #
  # Example:
  #   USAddressClient.verify(address: "2811 Safe Harbor Drive", city: "Tampa", state: "FL", zip: "33618")
  def self.verify(address)
    Client.verify(address)
  rescue ServiceError
    # Fallback to no delivery_point and continue processing as though the address was not matched.
    Address.new(address, true)
  end

  # Returns version and license information from the Address Service.
  #
  # Example:
  #   USAddressClient.version
  def self.version
    Client.version
  end

  # Returns whether to use mocked calls for address verification.
  def self.mocked?
    SecretConfig.fetch('us_address_client/mocked', type: :boolean, default: false)
  end
end
