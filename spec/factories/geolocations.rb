FactoryBot.define do
  factory :geolocation do
    ip { '1.2.3.4' }
    continent_code { 'NA' }
    continent_name { 'North America' }
    country_code { 'US' }
    country_name { 'United States' }
    region_code { 'CA' }
    region_name { 'California' }
    city { 'Los Angeles' }
    latitude { '34.0453' }
    longitude { '-118.2413' }
  end
end
