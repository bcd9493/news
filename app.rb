require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "9e7da56190cbaf7f50b97dda1c4adcdd"
forecast = ForecastIO.forecast(42.0574063,-87.6722787).to_hash

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
    "#{lat_long[0]} #{lat_long[1]}"

  
end