require "date"
module USAddressClient
  class Parser
    def self.parse_verify_response(response)
      hash                = JSON.parse(response, symbolize_names: true)
      hash[:result_codes] = hash[:result_codes].split(",") if hash.key?(:result_codes)
      hash
    rescue StandardError => e
      message = "Invalid data returned from Address Service. #{e.class.name}: #{e.message}"
      USAddressClient.logger.error(message: message, metric: "Supplier/USAddressClient/exception", exception: e, payload: hash)
      raise(ServiceError, message)
    end

    def self.parse_version_response(response)
      hash                           = JSON.parse(response, symbolize_names: true)
      hash[:database_date]           = Date.parse(hash[:database_date])
      # Date when the current U.S. data files expire. This date enables you to confirm that the
      # data files you are using are the latest available.
      hash[:expiration_date]         = Date.strptime(hash[:expiration_date], "%m-%d-%Y")
      hash[:license_expiration_date] = Date.parse(hash[:license_expiration_date])
      hash
    rescue StandardError => e
      message = "Invalid data returned from Address Service#verify. #{e.class.name}: #{e.message}"
      USAddressClient.logger.error(message: message, metric: "Supplier/USAddressClient/exception", exception: e, payload: hash)
      raise(ServiceError, message)
    end
  end
end
