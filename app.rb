require 'sinatra'
require 'amazon/ecs'
require_relative 'api.rb'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

load './local_env.rb' if File.exist?('./local_env.rb')




get '/' do
	# upc_info = params[:html_info]
	# print(upc_info)
	erb :input
end

post '/get_info' do
  upc = params[:upc]
  html_info = get_upc_info(upc)
  # print(html_info)
  # redirect '/product?results='+results
  erb :results, locals: {product_info: html_info}
end  

post '/return_home' do
	redirect '/'
end

get '/hidden_page' do
	upc = params[:upc]
  html_info = get_upc_info(upc)
  erb :results, locals: {product_info: html_info}
end

#this is just to trigger gits change monitor 