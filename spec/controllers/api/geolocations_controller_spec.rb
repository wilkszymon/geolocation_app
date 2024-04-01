RSpec.describe Api::GeolocationsController do
  describe 'GET #show' do
    context 'when geolocation exists' do
      let(:geolocation) { create(:geolocation) }

      before { get :show, params: { ip: geolocation.ip } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eql(geolocation.to_json) }
    end

    context 'when geolocation does not exist' do
      before { get :show, params: { ip: '0.0.0.0' } }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to eql({ error: 'Record not found' }.to_json) }
    end

    context 'when url is not valid' do
      before { get :show, params: { url: 'https://www.test.pl/path/to/resource?query_param=value' } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eql({ error: 'Invalid IP or URL' }.to_json) }
    end

    context 'when ip is not valid' do
      before { get :show, params: { ip: '0.0' } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eql({ error: 'Invalid IP or URL' }.to_json) }
    end
  end

  describe 'DELETE #destroy' do
    context 'when token is not valid' do
      before { delete :destroy, params: { ip: '0.0.0.0' } }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eql({ error: 'Bad credentials' }.to_json) }
    end

    context 'when token is valid' do
      before { request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(A9n.api.access_key) }

      context 'when geolocation exists' do
        let(:geolocation) { create(:geolocation) }

        before do
          delete :destroy, params: { ip: geolocation.ip }
        end

        it { expect(response).to have_http_status(:no_content) }
        it { expect(Geolocation.exists?(ip: geolocation.ip)).to be_falsey }
      end

      context 'when geolocation does not exist' do
        before { delete :destroy, params: { ip: '0.0.0.0' } }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.body).to eql({ error: 'Record not found' }.to_json) }
      end
    end
  end

  describe 'POST #create' do
    context 'when token is not valid' do
      before { post :create, params: { ip: '0.0.0.0' } }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eql({ error: 'Bad credentials' }.to_json) }
    end

    context 'when token is valid' do
      before { request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(A9n.api.access_key) }

      context 'when geolocation does not exist' do
        let(:geolocation) { build(:geolocation) }
        let(:ip) { '2.3.4.5' }

        before do
          allow(Geolocations::Builder).to receive(:perform).with(ip).and_return(geolocation)
          allow(geolocation).to receive(:save).and_return(true)

          post :create, params: { geolocation: { ip: } }
        end

        it { expect(response).to have_http_status(:created) }
        it { expect(response.body).to eql(geolocation.to_json) }
      end

      context 'when geolocation exists' do
        let(:geolocation) { create(:geolocation) }

        before { post :create, params: { geolocation: { ip: geolocation.ip } } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.body).to eql({ error: 'Geolocation already exists for this IP' }.to_json) }
      end

      context 'when url is not valid' do
        before { post :create, params: { geolocation: { url: 'https://www.test.pl/path/to/resource?query_param=value' } } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.body).to eql({ error: 'Invalid IP or URL' }.to_json) }
      end

      context 'when ip is not valid' do
        before { post :create, params: { geolocation: { ip: '0.0' } } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.body).to eql({ error: 'Invalid IP or URL' }.to_json) }
      end

      context 'when geolocation request fails' do
        let(:ip) { '1.2.3.4' }
        let(:client) { instance_double(Ipstack::Client, fetch_geolocation: nil) }

        before do
          allow(Ipstack::Client).to receive(:instance).and_return(client)
          allow(client).to receive(:fetch_geolocation).and_raise(Ipstack::RequestFailed, 'Request failed')

          post :create, params: { geolocation: { ip: } }
        end

        it { expect(response).to have_http_status(:bad_gateway) }
        it { expect(response.body).to eql({ error: 'Request failed, contact support' }.to_json) }
      end
    end
  end
end
