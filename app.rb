require 'sinatra'
require 'amazon/ecs'
require_relative 'api.rb'
require_relative 'api_upc_db.rb'
require_relative 'dsld_api.rb'

# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

load './local_env.rb' if File.exist?('./local_env.rb')




get '/' do
	# upc_info = params[:html_info]
	# print(upc_info)
	erb :input
end

post '/get_info' do
  upc = params[:upc]
  html_info = get_upc_info(upc)
  error_check = xml_error_check(html_info)
  error_message = ''

  spaced_upc = add_spacing_to_upc(upc)
  dsld_info = get_dsld_api_result(spaced_upc)

  if error_check == ''
    product_title = get_xml_product_title(html_info)
    product_price = get_xml_product_price(html_info)
    large_photos_array = get_xml_large_images(html_info)
    product_features = get_xml_product_features(html_info)
    product_type_name = get_xml_product_type_name(html_info)
    suggested_use = ''
  elsif get_id_from_result(dsld_info) != ''
      id = get_id_from_result(dsld_info)
      info = get_dsld_lable_info(id)
      product_title = get_product_name(info)
      product_price = ''
      large_photos_array = ['']
      product_features = ['']
      product_type_name = get_statement_of_identity(info)
      suggested_use = get_suggested_use(info)
      error_check = ''
  else html_info = get_nutrionix_info(upc)
    if error_check_nutritionix(html_info) == 'resource not found'
      product_title = ''
      product_price = ''
      large_photos_array = ''
      product_features = ['']
      product_type_name = ''
      suggested_use = ''
      error_message = "Item not Found"
    elsif error_check_nutritionix(html_info) == 'usage limits exceeded'
      product_title = ''
      product_price = ''
      large_photos_array = ''
      product_features = ['']
      product_type_name = ''
      suggested_use = ''
      error_message = "Item not Found on Amazon and Usage Limit Exceeded for NutritionIX API"
    else
      html_info = get_nutrionix_info(upc)
      product_title = get_nutritionix_product_title(html_info)
      product_price = ''
      large_photos_array = [get_nutritionix_large_images(html_info)]
      product_features = ['']
      product_type_name = ''
      suggested_use = ''
    end
  end
    erb :results, locals: {product_info: html_info, large_photos_array: large_photos_array, product_title: product_title, product_price: product_price, product_features: product_features, product_type_name: product_type_name, suggested_use: suggested_use, error: error_check}
end  

post '/return_home' do
	redirect '/'
end

get '/hidden_page' do
  upc = params[:upc]
  html_info = get_upc_info(upc)
  error_check = xml_error_check(html_info)
  error_message = ''

  spaced_upc = add_spacing_to_upc(upc)
  dsld_info = get_dsld_api_result(spaced_upc)

  if error_check == ''
    product_title = get_xml_product_title(html_info)
    product_price = get_xml_product_price(html_info)
    large_photos_array = get_xml_large_images(html_info)
    product_features = get_xml_product_features(html_info)
    product_type_name = get_xml_product_type_name(html_info)
  elsif get_id_from_result(dsld_info) != ''
      product_title = get_product_name(dsld_info)
      product_price = ''
      large_photos_array = ['']
      product_features = ['']
      product_type_name = get_statement_of_identity(dsld_info)
      error_check = ''
  else html_info = get_nutrionix_info(upc)
    if error_check_nutritionix(html_info) == 'resource not found'
      product_title = ''
      product_price = ''
      large_photos_array = ''
      product_features = ['']
      product_type_name = ''
      error_message = "Item not Found"
    elsif error_check_nutritionix(html_info) == 'usage limits exceeded'
      product_title = ''
      product_price = ''
      large_photos_array = ''
      product_features = ['']
      product_type_name = ''
      error_message = "Item not Found on Amazon and Usage Limit Exceeded for NutritionIX API"
    else
      html_info = get_nutrionix_info(upc)
      product_title = get_nutritionix_product_title(html_info)
      product_price = ''
      large_photos_array = [get_nutritionix_large_images(html_info)]
      product_features = ['']
      product_type_name = ''
    end
  end
    erb :results, locals: {product_info: html_info, large_photos_array: large_photos_array, product_title: product_title, product_price: product_price, product_features: product_features, product_type_name: product_type_name, error: error_check}
end  


#this is just to trigger gits change monitor 