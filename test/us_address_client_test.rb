require 'net/http'
require 'json'
require_relative 'test_helper'

class USAddressClientTest < Minitest::Test
  describe USAddressClient do
    it 'successful verify' do
      address  = {address: '2811 Safe Harbor Dr', city: 'Tampa', state: 'FL', zip: '33618'}
      body     = address.to_json
      response = stub_request(Net::HTTPSuccess, 200, 'OK', body) do
        USAddressClient.verify(address)
      end
      expected = USAddressClient::Address.new(address: '2811 Safe Harbor Dr', city: 'Tampa', state: 'FL', zip: '33618')
      assert_equal expected.attributes, response.attributes
    end

    it 'failed verify' do
      address  = {address: '2811 Safe Harbor Dr', city: 'Tampa', state: 'FL', zip: '33618'}
      response = stub_request(Net::HTTPInternalServerError, 500, 'ERROR', "") do
        USAddressClient.verify(address)
      end
      expected = USAddressClient::Address.new(address: '2811 Safe Harbor Dr', city: 'Tampa', state: 'FL', zip: '33618')
      assert_equal expected.attributes, response.attributes
    end

    it 'successful version' do
      response = USAddressClient::Client.version
      assert response[:mock]
      assert response[:license_expiration_date]
      assert response[:expiration_date]
    end

    def stub_request(klass, code, msg, body, &block)
      response = klass.new('1.1', code, msg)
      response.stub(:body, body) do
        USAddressClient.stub(:mocked?, false) do
          USAddressClient::Client.http.driver.stub(:request, response, &block)
        end
      end
    end
  end
end
