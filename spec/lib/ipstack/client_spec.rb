describe Ipstack::Client do
  subject(:client) { described_class.instance }

  let(:config) { A9n.ipstack }
  let(:faraday_instance) { double }
  let(:request_options) { { timeout: 30 } }
  let(:ip) { '68.183.209.74' }
  let(:path) { "/#{ip}?access_key=#{config.access_key}" }

  before do
    allow(Faraday).to receive(:new).with({ url: config.host_api, request: request_options }).and_return(faraday_instance).once
  end

  describe '#fetch_geolocation' do
    let(:response_status) { 200 }
    let(:response) { instance_double(Faraday::Response, status: response_status, body: { 'success' => true }.to_json) }

    before do
      allow(faraday_instance).to receive(:get).with(path, nil).and_return(response).once
    end

    context 'when response status is 200' do
      it do
        expect(client.fetch_geolocation(ip, config.access_key)).to eql({ 'success' => true })
      end
    end

    context 'when response status is not 200' do
      let(:response_status) { 500 }
      let(:response) { instance_double(Faraday::Response, status: response_status, body: { 'success' => false }.to_json) }

      it do
        expect { client.fetch_geolocation(ip, config.access_key) }.to raise_exception(Ipstack::RequestFailed)
      end
    end
  end
end
