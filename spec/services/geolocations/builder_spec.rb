RSpec.describe Geolocations::Builder do
  let(:builder) { described_class.new(ip) }
  let(:ip) { '127.0.0.1' }

  describe '#perform' do
    let(:geolocation_attributes) { { city: 'New York', country: 'USA' } }
    let(:geolocation) { instance_double(Geolocation) }
    let(:config) { A9n.ipstack.access_key }

    before do
      allow(Geolocation).to receive(:new).and_return(geolocation_attributes)
      allow(Ipstack::Client).to receive(:instance).and_return(client)
    end

    context 'when the geolocation request is successful' do
      let(:client) { instance_double(Ipstack::Client, fetch_geolocation: geolocation_attributes) }

      before do
        allow(client).to receive(:fetch_geolocation).with(ip, config).and_return(geolocation_attributes)
      end

      it 'returns a new geolocation instance' do
        expect(builder.perform).to eql(geolocation_attributes)
      end
    end

    context 'when the geolocation request fails' do
      let(:client) { instance_double(Ipstack::Client, fetch_geolocation: nil) }

      before do
        allow(client).to receive(:fetch_geolocation).and_raise(Ipstack::RequestFailed, 'Request failed')
      end

      it 'raises a RequestFailed error' do
        expect { builder.perform }.to raise_error(Ipstack::RequestFailed, 'Request failed')
      end
    end
  end
end
