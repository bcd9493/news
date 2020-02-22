require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     


# enter your Dark Sky API key here
ForecastIO.api_key = "9e7da56190cbaf7f50b97dda1c4adcdd"

# News API
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=72062d412df44b118b2b3128033cf057"
news = HTTParty.get(url).parsed_response.to_hash

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else

results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    location = results.first.city

# Define the lat and long
lat = "#{lat_long [0]}"
long = "#{lat_long [1]}"

# Results from Geocoder
forecast = ForecastIO.forecast("#{lat}" , "#{long}").to_hash

current_temperature = forecast["currently"]["temperature"]
conditions = forecast["currently"]["summary"]

puts "In #{location}, it is currently #{current_temperature} and #{conditions}"
# high_temperature = forecast["daily"]["data"][0]["temperatureHigh"]
# puts high_temperature
# puts forecast["daily"]["data"][1]["temperatureHigh"]
# puts forecast["daily"]["data"][2]["temperatureHigh"]

for day_forecast in forecast["daily"]["data"]
  puts "A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}."
end

end