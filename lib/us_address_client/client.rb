require "date"
require "sync_attr"

module USAddressClient
  class Client
    # Ensure that only one instance is created by using a mutex.
    # Once created a mutex is not used again since there is no writer accessor.
    sync_cattr_reader :http do
      OpinionatedHTTP.new(
        secret_config_prefix: "us_address_client",
        metric_prefix:        "USAddressClient",
        logger:               USAddressClient.logger,
        error_class:          ServiceError
      )
    end

    def self.verify(input_address)
      return AddressMock.new(input_address) if USAddressClient.mocked?

      response = http.get(action: "address", parameters: input_address, headers: {"Content-Type" => "application/json"})
      hash     = Parser.parse_verify_response(response.body!)
      USAddressClient.logger.trace(payload: hash)
      Address.new(hash, true)
    end

    def self.version
      if USAddressClient.mocked?
        return {
          license_expiration_date: Date.today + 365,
          expiration_date:         Date.today + 365,
          mock:                    true
        }
      end

      response = http.get(action: "version", headers: {"Content-Type" => "application/json"})
      Parser.parse_version_response(response.body!)
    end
  end
end
