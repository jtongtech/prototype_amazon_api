#!/usr/bin/env ruby

require 'time'
require 'uri'
require 'openssl'
require 'base64'
require 'open-uri'
require 'nokogiri'

# Your Access Key ID, as taken from the Your Account page
ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID']

# Your Secret Key corresponding to the above ID, as taken from the Your Account page
SECRET_KEY = ENV['SECRET_KEY']

# The region you are interested in
ENDPOINT = "webservices.amazon.com"

REQUEST_URI = "/onca/xml"

def get_input


end


params = {
  "Service" => "AWSECommerceService",
  "Operation" => "ItemLookup",
  ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID'], #from locals
  AWS_AFFILIATE_KEY = ENV['AWS_AFFILIATE_KEY'], #from locals
  "ItemId" => "028400070980", #variable from user input
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

monkeys = Nokogiri::HTML(open(request_url))
puts monkeys
# puts "Signed URL: \"#{request_url}\""