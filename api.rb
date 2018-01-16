#!/usr/bin/env ruby

require 'time'
require 'uri'
require 'openssl'
require 'base64'
require 'open-uri'
require 'nokogiri'
load './local_env.rb' if File.exist?('./local_env.rb')

# Your Access Key ID, as taken from the Your Account page
ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID']

# Your Secret Key corresponding to the above ID, as taken from the Your Account page
SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']

# The region you are interested in
ENDPOINT = "webservices.amazon.com"

REQUEST_URI = "/onca/xml"

def get_upc_info(asin)

  params = {
    "Service" => "AWSECommerceService",
    "Operation" => "ItemLookup",
    "AWSAccessKeyId" => ENV['AWS_ACCESS_KEY_ID'], #from locals
    "AssociateTag" => ENV['AWS_SECRET_ACCESS_KEY'], #from locals
    "ItemId" => asin, #variable from user input
    "IdType" => "ASIN", #variable from dropdown
    "ResponseGroup" => "Images,ItemAttributes,ItemIds"
    # "SearchIndex" => "All"
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
  # print("XML REQUEST: #{xml_request}")
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

def error_check(html_info)
  error = html_info.css('errors error message').text
  error
end

def get_large_images(html_info)
  
  large_image = []
  html_info.css('largeimage url').each do |img|
    if large_image.include?(img.text) == false
      large_image << img.text
    end
  end

  large_image
end

def get_product_title(html_info)
  title = html_info.css('title')[0].text
  title
end

def get_product_price(html_info)
  price = html_info.css('formattedprice')[0].text
  price
end

def get_product_features(html_info)
  features = []

  features
end



############## XML CALLS ##############

def xml_error_check(item)
  first_item = item.css("Items")
  error = item.css('Errors Error Message').text
  # print(error, "<------------this is error")
  error
end

def get_xml_product_title(item)
  # first_item = html_info.css("Item")[0]
  title = item.css("Title").text
  # print(title, "THIS IS TITLE!!!!")
  title
end

def get_xml_product_price(item)
  # first_item = html_info.css("Item")[0]
  price = item.css("FormattedPrice").text
  # print(price, "THIS IS PRICE!!!!")
  price
end

def get_xml_product_features(item)
  # first_item = html_info.css("Item")[0]
  features = []
  item.css("Feature").each do |feat|
    features << feat.text
  end
  # print(features, "THIS IS FEATURES!!!!")
  features
end

def get_xml_large_images(html_info)
first_item = html_info.css("Item")
# print(first_item, "THIS IS first_item!!!!")
  large_image = []
  first_item.css("LargeImage URL").each do |url|
    # print(url, "THIS IS url!!!!")
    if large_image.include?(url.text) == false
      large_image << url.text
    end
  end
  # print(large_image, "THIS IS large_image!!!!")
  large_image
end

def get_xml_product_type_name(item)
  # first_item = html_info.css("Item")[0]
  product_type_name = item.css("ProductTypeName").text.gsub!(/_/, ' ')
  # print(product_type_name, "THIS IS TYPE NAME!!!!")
  product_type_name
end
