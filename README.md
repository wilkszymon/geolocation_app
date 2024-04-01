# Geolocation App

This is a geolocation application that allows you to add and display the location of a device. The application uses the Geolocation API to get the current location of the device. The API is supported to add, delete and provide the location of the device. 

## Installation

To install the Geolocation App, follow these steps:

1. Clone the repository: `git clone https://github.com/your-username/geolocation_app.git`
2. Navigate to the project directory: `cd geolocation_app`
3. Install ruby version 3.2.2
4. Install the dependencies: `bundle install`
5. Add `access_key` iPstack API key in `./config/a9n/ipstack.yml.example`
6. To utilize the create and destroy actions, you must perform authentication by including the following header in your request: `Authorization: Bearer d03ef611597c5739c1d244577932596d716f07d0ba83c5240c6562f0cc48d8c3`

## Testing

## 1. POST action to create a new location

 a) with IP -> `.../api/geolocations`
 
  https://github.com/wilkszymon/geolocation_app/assets/44979962/3071449a-379f-4c77-af99-694ad72fb984

 b) with url -> `.../api/geolocations`
 
  https://github.com/wilkszymon/geolocation_app/assets/44979962/d0df0cb9-b0cc-4825-a172-c6632a625c61

## 2. GET action to provide the location

  a) with IP -> `.../api/geolocations?ip=68.183.209.75`

  https://github.com/wilkszymon/geolocation_app/assets/44979962/4441df5f-df0e-4dd1-a18f-070942d6ab6e

  b) with url -> `.../api/geolocations?url=https://78.88.187.20/path/...`

  https://github.com/wilkszymon/geolocation_app/assets/44979962/ed79aa51-37fb-456e-aec0-0397dffc0213

## 3. DELETE action

  a) with IP -> `.../api/geolocations?ip=68.183.209.75`

  https://github.com/wilkszymon/geolocation_app/assets/44979962/50a8493a-7602-4d5b-b88a-6e28d0e3bccc

  b) with url -> `.../api/geolocations?url=https://78.88.187.20/path/...`

  https://github.com/wilkszymon/geolocation_app/assets/44979962/fe870b50-c959-422a-a6cc-70727f5b2f71










