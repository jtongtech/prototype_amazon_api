require 'sinatra'
require 'amazon/ecs'
require_relative 'api.rb'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

load './local_env.rb' if File.exist?('./local_env.rb')


get '/get_info' do
	upc = params[:upc]
	erb :input
end

post '/get_info' do

  redirect '/product?results='+results
end  

#this is just to trigger gits change monitor 