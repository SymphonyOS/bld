#!/usr/bin/env ruby

require 'sinatra'
require 'droplet-kit'

Tilt.register Tilt::ERBTemplate, 'html.erb'

get '/' do
    erb :main
end

