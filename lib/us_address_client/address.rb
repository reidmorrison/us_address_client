module USAddressClient
  class Address
    TIME_ZONES = {
      "04" => "Atlantic/Bermuda",
      "05" => "US/Eastern",
      "06" => "US/Central",
      "07" => "US/Mountain",
      "08" => "US/Pacific",
      "09" => "US/Alaska",
      "10" => "US/Hawaii",
      "11" => "US/Samoa",
      "13" => "Pacific/Majuro",
      "14" => "Pacific/Guam",
      "15" => "Pacific/Palau"
    }.freeze

    # See  http://wiki.melissadata.com/index.php?title=Result_Code_Details#Address_Object
    def good_codes
      @good_codes ||= SecretConfig.fetch(
        "us_address_client/good_codes",
        default:   %w[AS01 AS02 AS03],
        separator: ","
      ).freeze
    end

    def bad_codes
      @bad_codes ||= SecretConfig.fetch(
        "us_address_client/bad_codes",
        default:   %w[AC02 AC03],
        separator: ","
      ).freeze
    end

    ATTRIBUTES = %i[
      address
      address2
      suite
      city
      state
      zip
      plus4
      address_key
      delivery_point
      time_zone_code
      time_zone
      address_type
      address_type_code
      suite_name
      suite_range
      address_range
      pre_direction
      post_direction
      street_name
      suffix
      private_mailbox_name
      private_mailbox_number
      garbage
      result_codes
    ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(attributes = {}, safe = false)
      safe ? safe_assign_attributes(attributes) : self.attributes = attributes
    end

    # At least 1 good code and no bad codes
    def valid?
      (result_codes & good_codes).present? && (result_codes & bad_codes).empty?
    end

    def time_zone_offset
      time_zone = TIME_ZONES[time_zone_code]
      return unless time_zone

      time_zone = "US/Arizona" if state == "AZ"
      Time.now.in_time_zone(time_zone).utc_offset / -60
    end

    def attributes=(attributes)
      attributes.each_pair { |key, value| public_send("#{key}=".to_sym, value) }
    end

    def attributes
      ATTRIBUTES.each_with_object({}) { |key, attributes| attributes[key] = public_send(key) }
    end

    private

    def safe_assign_attributes(attributes)
      attributes.each_pair do |key, value|
        next unless ATTRIBUTES.include?(key.to_sym)

        public_send("#{key}=".to_sym, value)
      end
    end
  end
end
