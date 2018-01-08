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
  # print("HTML_INFO!!!!!!!!!!!!!!!!!!!!!!!: #{html_info}")
  error_check = error_check(html_info)
  puts("error_check is: #{error_check}")
  if error_check == ''
    product_title = get_product_title(html_info)
    product_price = get_product_price(html_info)
    large_photos_array = get_large_images(html_info)
    # print(html_info)
    # redirect '/product?results='+results
  else
    product_title = ''
    product_price = ''
    large_photos_array = ['']
  end
    erb :results, locals: {product_info: html_info, large_photos_array: large_photos_array, product_title: product_title, product_price: product_price, error: error_check}
end  

post '/return_home' do
	redirect '/'
end

get '/hidden_page' do
	upc = params[:upc]
  html_info = get_upc_info(upc)
  
  product_title = get_product_title(html_info)
  product_price = get_product_price(html_info)
  large_photos_array = get_large_images(html_info)
  # print(html_info)
  # redirect '/product?results='+results
  erb :results, locals: {product_info: html_info, large_photos_array: large_photos_array, product_title: product_title, product_price: product_price}
end

#this is just to trigger gits change monitor 