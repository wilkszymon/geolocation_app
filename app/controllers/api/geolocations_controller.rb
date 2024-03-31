require 'uri'
require 'ipaddr'

module Api
  class GeolocationsController < ApplicationController
    before_action :authenticate, only: %i[create destroy]
    before_action :prepare_geolocation, only: %i[show destroy]
    before_action :set_geolocation, only: %i[show destroy]

    def show
      render json: @geolocation
    end

    def create
      ip_or_url = geolocation_params[:ip] || geolocation_params[:url]
      ip = url_valid?(ip_or_url) ? extract_ip_from_url(ip_or_url) : ip_or_url

      if ip_valid?(ip)
        return exist_geolocation_input if Geolocation.exists?(ip:)

        begin
          create_geolocation(ip)
        rescue ::Ipstack::RequestFailed
          handle_request_failed
        end
      else
        handle_invalid_input
      end
    end

    def destroy
      @geolocation.destroy
      head :no_content
    end

    private

    def builder_geolocation(ip)
      @builder_geolocation ||= ::Geolocations::Builder.perform(ip)
    end

    def create_geolocation(ip_or_url)
      geolocation = builder_geolocation(ip_or_url)
      if geolocation.save
        render json: geolocation, status: :created
      else
        render json: { errors: geolocation.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def handle_invalid_input
      render json: { error: 'Invalid IP or URL' }, status: :unprocessable_entity
    end

    def exist_geolocation_input
      render json: { error: 'Geolocation already exists for this IP' }, status: :unprocessable_entity
    end

    def prepare_geolocation
      ip_or_url = params[:ip] || params[:url]
      @ip = url_valid?(ip_or_url) ? extract_ip_from_url(ip_or_url) : ip_or_url

      handle_invalid_input unless @ip.present? && ip_valid?(@ip)
    end

    def set_geolocation
      @geolocation = Geolocation.find_by!(ip: @ip)
    end

    def extract_ip_from_url(url)
      URI.parse(url).host
    end

    def ip_valid?(str)
      IPAddr.new(str).ipv4? || IPAddr.new(str).ipv6?
    rescue IPAddr::InvalidAddressError
      false
    end

    def url_valid?(str)
      uri = URI.parse(str)
      uri.scheme.present? && uri.host.present?
    rescue URI::InvalidURIError
      false
    end

    def geolocation_params
      params.require(:geolocation).permit(:url, :ip)
    end
  end
end
