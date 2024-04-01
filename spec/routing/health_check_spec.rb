require 'rails_helper'

describe 'routes to /up' do
  it 'routes to rails/health#show' do
    expect(get: '/up').to route_to('rails/health#show')
  end
end
