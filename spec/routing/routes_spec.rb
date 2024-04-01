describe 'routes' do
  specify { expect(get: '/up').to route_to('rails/health#show') }
  specify { expect(get: '/api/geolocations').to route_to('api/geolocations#show') }
  specify { expect(delete: '/api/geolocations').to route_to('api/geolocations#destroy') }
  specify { expect(post: '/api/geolocations').to route_to('api/geolocations#create') }
  specify { expect(get: '/unmatched').to route_to('application#handle_invalid_request', unmatched: 'unmatched') }
  specify { expect(post: '/unmatched').to route_to('application#handle_invalid_request', unmatched: 'unmatched') }
  specify { expect(put: '/unmatched').to route_to('application#handle_invalid_request', unmatched: 'unmatched') }
  specify { expect(delete: '/unmatched').to route_to('application#handle_invalid_request', unmatched: 'unmatched') }
end
