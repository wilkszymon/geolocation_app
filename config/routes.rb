Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get "geolocations", to: "geolocations#show"
    delete "geolocations", to: "geolocations#destroy"
    post "geolocations", to: "geolocations#create"
  end
end
