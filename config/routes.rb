Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get "geolocations", to: "geolocations#show"
    delete "geolocations", to: "geolocations#destroy"
    post "geolocations", to: "geolocations#create"
  end

  match '*unmatched', to: 'application#handle_invalid_request', via: :all
end
