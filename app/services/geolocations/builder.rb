module Geolocations
  class Builder
    extend ::Performable

    def initialize(ip)
      @ip = ip
    end

    def perform
      Geolocation.new(geolocation_attributes)
    end

    private

    attr_reader :ip

    def fetch_geolocation
      client.fetch_geolocation(ip, ::A9n.ipstack.access_key)
    end

    def geolocation_attributes
      {
        ip: fetch_geolocation['ip'],
        continent_code: fetch_geolocation['continent_code'],
        continent_name: fetch_geolocation['continent_name'],
        country_code: fetch_geolocation['country_code'],
        country_name: fetch_geolocation['country_name'],
        region_code: fetch_geolocation['region_code'],
        region_name: fetch_geolocation['region_name'],
        city: fetch_geolocation['city'],
        latitude: fetch_geolocation['latitude'],
        longitude: fetch_geolocation['longitude']
      }
    end

    def client
      @client ||= ::Ipstack::Client.instance
    end
  end
end
