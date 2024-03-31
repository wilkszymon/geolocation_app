module Ipstack
  class RequestFailed < StandardError; end

  class Client
    include Singleton

    def fetch_geolocation(ip, access_key)
      request(:get, "/#{ip}?access_key=#{access_key}")
    end

    private

    delegate :host_api, to: :config, private: true

    def request(method, path, body: nil)
      response = connection.send(method, path, body).tap do |resp|
        hash = JSON.parse(resp.body)

        raise ::Ipstack::RequestFailed, "response: { status: #{hash.dig('error', 'code')}, body: #{hash.dig('error', 'info')} }" if hash['success'] == false
      end

      JSON.parse(response.body)
    end

    def connection
      ::Faraday.new(options)
    end

    def options
      {
        url: host_api,
        request: timeout_options
      }
    end

    def timeout_options
      { timeout: 30 }
    end

    def config
      @config ||= ::A9n.ipstack
    end
  end
end
