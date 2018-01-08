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

def get_upc_info(upc)

  params = {
    "Service" => "AWSECommerceService",
    "Operation" => "ItemLookup",
    "AWSAccessKeyId" => ENV['AWS_ACCESS_KEY_ID'], #from locals
    "AssociateTag" => ENV['AWS_SECRET_ACCESS_KEY'], #from locals
    "ItemId" => upc, #variable from user input
    "IdType" => "UPC", #variable from dropdown
    "ResponseGroup" => "Images,ItemAttributes,ItemIds",
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

  html_result = Nokogiri::HTML(open(request_url))
  # monkeys.css('largeimage').each do |monkey|
  puts "THIS IS html_result: #{html_result}"
  # end
  # puts "Signed URL: \"#{request_url}\""
  html_result
end

