require 'rack'
require 'rack/contrib'
require 'sinatra'
require './app/util'
require './app/move'

use Rack::PostBodyContentTypeParser

appearance = {
  color: "#00FF00",
  head_type: "regular",
  tail_type: "regular",
}

get '/' do
  "Battlesnake documentation can be found at <a href=\"https://docs.battlesnake.io\">docs.battlesnake.io</a>\n"
end

post '/ping' do
  "ok\n"
end

post '/start' do
  content_type :json
  camelcase(appearance).to_json
end

post '/move' do
  request = underscore(env['rack.request.form_hash'])
  response = move(request)
  content_type :json
  camelcase(response).to_json
end

post '/end' do
  "end\n"
end
