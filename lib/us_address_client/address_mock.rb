require 'active_support'
require 'active_support/core_ext'

module USAddressClient
  class AddressMock < Address
    def initialize(fields)
      @result_codes   = ['AS01']
      @address_type   = 'Street'
      @time_zone_code = '05'
      @plus4          = '1234'
      super(fields)
    end

    def valid?
      zip.present?
    end

    def delivery_point
      return if zip.blank?

      delivery_point_code = zip[3..5]
      "#{zip}#{plus4}#{delivery_point_code}"
    end

    def address_key
      delivery_point
    end
  end
end
