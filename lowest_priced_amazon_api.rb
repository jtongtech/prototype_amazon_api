#!/usr/bin/env ruby

require 'time'
require 'uri'
require 'openssl'
require 'base64'
require 'open-uri'
require 'nokogiri'
load './local_env.rb' if File.exist?('./local_env.rb')

# Your Access Key ID, as taken from the Your Account page
 # ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID']

# Your Secret Key corresponding to the above ID, as taken from the Your Account page
 # SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']

 # The region you are interested in
 # ENDPOINT = "webservices.amazon.com"

 # REQUEST_URI = "/onca/xml"

def get_amazon_info(upc)

  params = {
    "Service" => "AWSECommerceService",
    "Operation" => "ItemLookup",
    "AWSAccessKeyId" => ENV['AWS_ACCESS_KEY_ID'], #from locals
    "AssociateTag" => ENV['AWS_SECRET_ACCESS_KEY'], #from locals
    "ItemId" => upc, #variable from user input
    "IdType" => "UPC", #variable from dropdown
    "ResponseGroup" => "Offers",
    "SearchIndex" => "All"
  }

  # Set current timestamp if not set
  params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

  # Generate the canonical query
  canonical_query_string = params.sort.collect do |key, value|
    [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
  end.join('&')

  # Generate the string to be signed
  string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"

  # Generate the signature required by the Product Advertising API
  signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), SECRET_KEY, string_to_sign)).strip()

  # Generate the signed URL
  request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"

  # print("REQUEST_URL: #{request_url}")
  xml_request = Nokogiri::XML(open(request_url))
  # print(xml_request, "XML REQUEST")
  item = []
  xml_request.css('Item ItemAttributes ListPrice FormattedPrice').each do |price|
    item << price.text
  end

  # item = xml_request.css('Item ')[0]
  # print("ITEM: #{item}")

  html_result = Nokogiri::HTML(open(request_url))
  # monkeys.css('largeimage').each do |monkey|
  #puts "THIS IS html_result: #{html_result}"
  # end
  # puts "Signed URL: \"#{request_url}\""
  # html_result
  xml_request
end

def get_listed_items_array(upc)

  api_object = get_amazon_info(upc)
  items_object = api_object.css("Items")
  items_array = []
  items_object.css("Item").each do |single_item_object|
    # puts(single_item_object, "<---------------------- single_item_object is here")
    items_array << single_item_object
  end
  # print(items_array, "items_object is here")
  items_array
end

def drop_array_items_with_no_new_items_available(items_array)
  index = 0
  index_delete_array = []
  items_array.each do |item|
    if item.css("OfferSummary TotalNew").text.to_i == 0
      index_delete_array << index
    end
    index += 1
  end

  index_delete_array.reverse.each do |i|
    items_array.delete_at(i)
  end

  items_array
end

def get_lowest_priced_item_index(items_array)
  lowest_priced_item_index = ''
  price = 1000000
  index_counter = 0
  items_array.each do |item|
    item_amount = item.css("OfferSummary Amount").text.to_i
    if item_amount < price || item_amount == 0
      lowest_priced_item_index = index_counter
      price = item.css("OfferSummary Amount").text.to_i
    end
    index_counter += 1
  end
 
  lowest_priced_item_index
end

def lowest_item(upc)
  items_array = get_listed_items_array(upc)
  available_items = drop_array_items_with_no_new_items_available(items_array)
  lowest_priced_item_index = get_lowest_priced_item_index(available_items)
  print(lowest_priced_item_index, "HERE IS INDEX")
  print(available_items, "AVAILABLE ITEMS")
  lowest_priced_item = available_items[lowest_priced_item_index.to_i]
  puts(lowest_priced_item, "LOWEST PRICED ITEM HERE")
  lowest_priced_item
end

# get_amazon_info("031604026745")
# def error_check(html_info)
#   error = html_info.css('errors error message').text
#   error
# end

# def get_large_images(html_info)
  
#   large_image = []
#   html_info.css('largeimage url').each do |img|
#     if large_image.include?(img.text) == false
#       large_image << img.text
#     end
#   end

#   large_image
# end

# def get_product_title(html_info)
#   title = html_info.css('title')[0].text
#   title
# end

# def get_product_price(html_info)
#   price = html_info.css('formattedprice')[0].text
#   price
# end

# def get_product_features(html_info)
#   features = []

#   features
# end



# ############## XML CALLS ##############

# def xml_error_check(html_info)
#   first_item = html_info.css("Items")[0]
#   error = first_item.css('Errors Error Message').text
#   print(error, "<------------this is error")
#   error
# end

# def get_xml_product_title(html_info)
#   first_item = html_info.css("Item")[0]
#   title = first_item.css("Title").text
#   print(title, "THIS IS TITLE!!!!")
#   title
# end

# def get_xml_product_price(html_info)
#   first_item = html_info.css("Item")[0]
#   price = first_item.css("FormattedPrice").text
#   print(price, "THIS IS PRICE!!!!")
#   price
# end

# def get_xml_product_features(html_info)
#   first_item = html_info.css("Item")[0]
#   features = []
#   first_item.css("Feature").each do |feat|
#     features << feat.text
#   end
#   print(features, "THIS IS FEATURES!!!!")
#   features
# end

# def get_xml_large_images(html_info)
# first_item = html_info.css("Item")
# print(first_item, "THIS IS first_item!!!!")
#   large_image = []
#   first_item.css("LargeImage URL").each do |url|
#     # print(url, "THIS IS url!!!!")
#     if large_image.include?(url.text) == false
#       large_image << url.text
#     end
#   end
#   print(large_image, "THIS IS large_image!!!!")
#   large_image
# end

# def get_xml_product_type_name(html_info)
#   first_item = html_info.css("Item")[0]
#   product_type_name = first_item.css("ProductTypeName").text.gsub!(/_/, ' ')
#   print(product_type_name, "THIS IS TYPE NAME!!!!")
#   product_type_name
# end
