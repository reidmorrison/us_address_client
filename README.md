# US Address Client

Ruby Client to call the privately hosted US Postal Address Service to verify and cleanse addresses.

## Status

Not for production use. US Postal Address Service is not yet open source to be able to use this client.

## Examples

Verify and cleanse an address:
~~~ruby
address = USAddressClient.verify(address: "2811 Safe Harbor Drive", city: "Tampa", state: "FL", zip: "33618")
# => #<USAddressClient::Address:0x00007feab8c06570 @zip="33618", @time_zone_code="05", @time_zone="Eastern Time", @suite_range="", @suite_name="", @suite="", @suffix="Dr", @street_name="Safe Harbor", @state="FL", @result_codes=["AS01"], @private_mailbox_number="", @private_mailbox_name="", @pre_direction="", @post_direction="", @plus4="4534", @melissa_address_key_base="", @melissa_address_key="", @garbage="", @delivery_point="33618453411", @city="Tampa", @address_type_code="S", @address_type="Street", @address_range="2811", @address2="", @address="2811 Safe Harbor Dr">
  
address.valid?
# => true
  
address.city
# => "Tampa"  
  
address.time_zone_offset
# => 300
  
address.attributes
# =>
{
                     :address => "2811 Safe Harbor Dr",
                    :address2 => "",
                       :suite => "",
                        :city => "Tampa",
                       :state => "FL",
                         :zip => "33618",
                       :plus4 => "4534",
         :melissa_address_key => "",
    :melissa_address_key_base => "",
              :delivery_point => "33618453411",
              :time_zone_code => "05",
                   :time_zone => "Eastern Time",
                :address_type => "Street",
           :address_type_code => "S",
                  :suite_name => "",
                 :suite_range => "",
               :address_range => "2811",
               :pre_direction => "",
              :post_direction => "",
                 :street_name => "Safe Harbor",
                      :suffix => "Dr",
        :private_mailbox_name => "",
      :private_mailbox_number => "",
                     :garbage => "",
                :result_codes => ["AS01"]
}
~~~

Obtain Melissa Data Quality Suite version and licensing information:
~~~ruby
USAddressClient.version
~~~

Output:
~~~ruby
{
    :license_expiration_date => Tue, 24 Sep 2019,
          :initialize_status => "No error.",
            :expiration_date => Thu, 31 Jan 2019,
              :database_date => Mon, 15 Oct 2018,
               :build_number => "3240"
}
~~~

### Configuration

Use Secret Config to supply the configuration settings for the Address Service. 
`url` is mandatory, below are the default settings for the remaining values:

~~~yaml
us_address_client:
  url:          http://address.service.test.com
  pool_size:    100
  open_timeout: 10
  read_timeout: 10
  idle_timeout: 300
  keep_alive:   300
  pool_timeout: 5
  warn_timeout: 0.25
  proxy:        :ENV
  force_retry: true
  mocked:      false
~~~

Mock out calls to Address Service:
~~~yaml
us_address_client:
  mocked: true
~~~

#### Notes:

- Configuration changes _must_ be made prior to any calls being made to this service.

### Logging

The Address Service logs to `USAddressClient.logger`. The log level can be changed at any time to increase
or decrease the logging output.

Below is sample output for each log level setting.

#### Info Logging

~~~ruby
USAddressClient.logger.level = :info
~~~

Output:

~~~
2018-12-19 19:30:05.257225 I [28643:70323013957920 client.rb:8] (7.351ms) USAddressClient -- #verify
~~~

#### Debug Logging

~~~ruby
USAddressClient.logger.level = :debug
~~~

Output:

~~~
2018-12-19 19:30:34.619759 D [28643:70323013957920 transport.rb:25] (8.319ms) USAddressClient -- #http_get -- { :path => "/address?address=2811+Safe+Harbor+Drive&city=Tampa&state=FL&zip=33618" }
2018-12-19 19:30:34.620862 I [28643:70323013957920 client.rb:8] (9.562ms) USAddressClient -- #verify -- { :input => { :address => "2811 Safe Harbor Drive", :city => "Tampa", :state => "FL", :zip => "33618" }, :output => { :zip => "33618", :time_zone_code => "05", :time_zone => "Eastern Time", :suite_range => "", :suite_name => "", :suite => "", :suffix => "Dr", :street_name => "Safe Harbor", :state => "FL", :result_codes => [ "AS01" ], :private_mailbox_number => "", :private_mailbox_name => "", :pre_direction => "", :post_direction => "", :plus4 => "4534", :melissa_address_key_base => "", :melissa_address_key => "", :garbage => "", :delivery_point => "33618453411", :city => "Tampa", :address_type_code => "S", :address_type => "Street", :address_range => "2811", :address2 => "", :address => "2811 Safe Harbor Dr" } }
~~~

#### Trace Logging

~~~ruby
USAddressClient.logger.level = :trace
~~~

With trace level logging PersistentHTTP and GenePool log messages are made available in the standard log files.

Output:

~~~
2018-12-19 19:34:08.118208 T [28643:70323013957920 transport.rb:56] USAddressClient -- HTTP: Checkout connection HTTP:0.0.0.0:4000(70323063570580) self=connections=70323063570580 checked_out=70323063570580 with_map=
2018-12-19 19:34:08.118455 T [28643:70323013957920 transport.rb:52] USAddressClient -- Conn close because of keep_alive_timeout
2018-12-19 19:34:08.119208 T [28643:70323013957920 transport.rb:52] USAddressClient -- opening connection to 0.0.0.0:4000...
2018-12-19 19:34:08.120509 T [28643:70323013957920 transport.rb:52] USAddressClient -- opened
2018-12-19 19:34:08.121268 T [28643:70323013957920 transport.rb:52] USAddressClient -- <-
2018-12-19 19:34:08.121478 T [28643:70323013957920 transport.rb:52] USAddressClient -- "GET /address?address=2811+Safe+Harbor+Drive&city=Tampa&state=FL&zip=33618 HTTP/1.1\r\nAccept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3\r\nAccept: */*\r\nUser-Agent: Ruby\r\nContent-Type: application/json\r\nConnection: keep-alive\r\nKeep-Alive: 300\r\nHost: 0.0.0.0:4000\r\n\r\n"
2018-12-19 19:34:08.133798 T [28643:70323013957920 transport.rb:52] USAddressClient -- -> "HTTP/1.1 200 OK\r\n"
2018-12-19 19:34:08.133938 T [28643:70323013957920 transport.rb:52] USAddressClient -- -> "cache-control: max-age=0, private, must-revalidate\r\n"
2018-12-19 19:34:08.134063 T [28643:70323013957920 transport.rb:52] USAddressClient -- -> "content-length: 524\r\n"
2018-12-19 19:34:08.134126 T [28643:70323013957920 transport.rb:52] USAddressClient -- -> "date: Wed, 19 Dec 2018 19:34:07 GMT\r\n"
2018-12-19 19:34:08.134182 T [28643:70323013957920 transport.rb:52] USAddressClient -- -> "server: Cowboy\r\n"
2018-12-19 19:34:08.134236 T [28643:70323013957920 transport.rb:52] USAddressClient -- -> "\r\n"
2018-12-19 19:34:08.134361 T [28643:70323013957920 transport.rb:52] USAddressClient -- reading 524 bytes...
2018-12-19 19:34:08.134422 T [28643:70323013957920 transport.rb:52] USAddressClient -- -> "{\"zip\":\"33618\",\"time_zone_code\":\"05\",\"time_zone\":\"Eastern Time\",\"suite_range\":\"\",\"suite_name\":\"\",\"suite\":\"\",\"suffix\":\"Dr\",\"street_name\":\"Safe Harbor\",\"state\":\"FL\",\"result_codes\":\"AS01\",\"private_mailbox_number\":\"\",\"private_mailbox_name\":\"\",\"pre_direction\":\"\",\"post_direction\":\"\",\"plus4\":\"4534\",\"melissa_address_key_base\":\"\",\"melissa_address_key\":\"\",\"garbage\":\"\",\"delivery_point\":\"33618453411\",\"city\":\"Tampa\",\"address_type_code\":\"S\",\"address_type\":\"Street\",\"address_range\":\"2811\",\"address2\":\"\",\"address\":\"2811 Safe Harbor Dr\"}"
2018-12-19 19:34:08.134470 T [28643:70323013957920 transport.rb:52] USAddressClient -- read 524 bytes
2018-12-19 19:34:08.134537 T [28643:70323013957920 transport.rb:52] USAddressClient -- Conn keep-alive
2018-12-19 19:34:08.134662 T [28643:70323013957920 transport.rb:56] USAddressClient -- HTTP: Checkin connection HTTP:0.0.0.0:4000(70323063570580) self=connections=70323063570580 checked_out= with_map=
2018-12-19 19:34:08.134716 D [28643:70323013957920 transport.rb:25] (16.6ms) USAddressClient -- #http_get -- { :path => "/address?address=2811+Safe+Harbor+Drive&city=Tampa&state=FL&zip=33618" }
2018-12-19 19:34:08.134845 I [28643:70323013957920 client.rb:8] (16.8ms) USAddressClient -- #verify -- { :input => { :address => "2811 Safe Harbor Drive", :city => "Tampa", :state => "FL", :zip => "33618" }, :output => { :zip => "33618", :time_zone_code => "05", :time_zone => "Eastern Time", :suite_range => "", :suite_name => "", :suite => "", :suffix => "Dr", :street_name => "Safe Harbor", :state => "FL", :result_codes => [ "AS01" ], :private_mailbox_number => "", :private_mailbox_name => "", :pre_direction => "", :post_direction => "", :plus4 => "4534", :melissa_address_key_base => "", :melissa_address_key => "", :garbage => "", :delivery_point => "33618453411", :city => "Tampa", :address_type_code => "S", :address_type => "Street", :address_range => "2811", :address2 => "", :address => "2811 Safe Harbor Dr" } }
~~~

## Customizing what is a good or bad address

Melissa Data returns good and bad codes after verifying the address. 

By default the following codes need to be returned before the address is considered valid: 
- AS01 
- AS02 
- AS03

To override these codes, set the `good_codes` value in secret config as a list of comma separated values:

~~~yaml
us_address_client:
  url:          http://address.service.test.com
  good_codes:   "AS01, AS02, AS03, AS20"
~~~

Even if a good code is returned, by default the following codes will force the result to be considered invalid: 
- AC02
- AC03 

To override these codes, set the `bad_codes` value in secret config as a list of comma separated values:

~~~yaml
us_address_client:
  url:          http://address.service.test.com
  bad_codes:    "AS03, AS09, AS16, AS17, AS24, AE01, AE02, AE03, AE04, AE05, AE07, AE10, AE11, AE12, AE13, AE14"
~~~
