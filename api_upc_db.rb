require 'uri'
require 'net/http'
require 'openssl'
require 'json'

load './local_env.rb' if File.exist?('./local_env.rb')

def get_nutrionix_info(upc)
    url = URI("https://trackapi.nutritionix.com/v2/search/item?upc="+ upc)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
    request["api-token"] = ENV['NutritionIX-token']
    request["x-app-id"] = ENV['AppID']
    request["x-app-key"] = ENV['AppKey']
    request["x-remote-user-id"] = '0'
    request["authorization"] = 'Basic aGV5dGhyaXZ5ZGV2M0BnbWFpbC5jb206TWluM2RNaW5kcw=='
    request["cache-control"] = 'no-cache'
    request["postman-token"] = 'a58f797e-422a-d004-c2bd-f5e2e6cee114'
    request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"user_id\"\r\n\r\n0000\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"nickname\"\r\n\r\nDouble07\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"profile_url\"\r\n\r\nhttps://sendbird.com/main/img/profiles/profile_05_512px.png\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"issue_access_token\"\r\n\r\ntrue\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"

    response = http.request(request)
    # puts response.read_body
    response
    data_hash = JSON.parse(response.read_body)
    puts data_hash
    data_hash
end

# get_nutrionix_info('1111')

def error_check_nutritionix(data_hash)
    nutritionix_error = data_hash['message']
    # puts nutritionix_error
    nutritionix_error
  end

def get_nutritionix_large_images(data_hash)
    large_image = data_hash['foods'][0]['photo']['thumb']  
    # puts large_image
    large_image
  end
  
  def get_nutritionix_product_title(data_hash)
    title = data_hash['foods'][0]['brand_name'] + " " + data_hash['foods'][0]['food_name']
    puts title
    title
  end
  
  def get_nutritionix_product_price(data_hash)
    price = "unknown"
    price
  end

  # upc = "11111111111111"
  # 50.times do
  # get_nutrionix_info(upc)
  # end