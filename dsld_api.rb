require 'uri'
require 'net/http'
require 'openssl'
require 'base64'
require 'open-uri'
require 'json'
# ​
dsld_id = ""
# spaced_upc = "0 30768 03268 5"
# spaced_upc = "0 23290 11111 0"
# get_dsld_id = URI("http://www.dsld.nlm.nih.gov/dsld/api/qsearch?searchterm=" + spaced_upc)
# get_dsld_info = URI("http://www.dsld.nlm.nih.gov/dsld/api/label/" + dsld_id)
# ​
def dsld_api(url)
    http = Net::HTTP.new(url.host, url.port)
    # ​
    request = Net::HTTP::Get.new(url)
    request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
    request["Api-Token"] = '3a419a74a2e469defe7e540fc9c088c47cba8075'
    request["x-app-id"] = 'cff06745'
    request["x-app-key"] = '2350a65b08cbeba13f13c627cf538e52'
    request["x-remote-user-id"] = '0'
    request["Authorization"] = 'Basic aGV5dGhyaXZ5ZGV2M0BnbWFpbC5jb206TWluM2RNaW5kcw=='
    request["Cache-Control"] = 'no-cache'
    request["Postman-Token"] = '21fab32d-ec75-04d0-0b64-ca165d3a3843'
    request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"user_id\"\r\n\r\n0000\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"nickname\"\r\n\r\nDouble07\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"profile_url\"\r\n\r\nhttps://sendbird.com/main/img/profiles/profile_05_512px.png\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"issue_access_token\"\r\n\r\ntrue\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
    # ​
    response = http.request(request)
    # puts response.read_body
    dsld_data_hash = JSON.parse(response.read_body)
    # dsld_id = dsld_data_hash["foundin_05_anyhwere"]["products"][0]["ID"]
    # puts dsld_id
    # puts(dsld_data_hash, "hash is here")
    dsld_data_hash

end

def add_spacing_to_upc(upc)
    upc.insert(1, ' ')
    upc.insert(7, ' ')
    upc.insert(13, ' ')
    upc
end

def get_dsld_api_result(upc)
    get_dsld_id = URI("http://www.dsld.nlm.nih.gov/dsld/api/qsearch?searchterm=" + upc)
    # dsld_id = dsld_api(get_dsld_id)["foundin_05_anyhwere"]["products"][0]["ID"]
    dsld_info = dsld_api(get_dsld_id)
    # print(dsld_id, "HERE IS ID RESULT")
    dsld_info
end

def get_id_from_result(dsld_info)
    id = ''
    if dsld_info["foundin_05_anyhwere"] != {}
        id = (dsld_info["foundin_05_anyhwere"]["products"][0]["ID"])
    end
    id
end

def get_dsld_lable_info(dsld_id)
    dsld_info = dsld_api(URI("http://www.dsld.nlm.nih.gov/dsld/api/label/" + dsld_id))
    dsld_info
end

def get_statement_of_identity(dsld_info)
    # id = get_id_from_result(dsld_info)
    # result = get_dsld_lable_info(id)
    statement_of_identity = dsld_info["Statement_of_Identity"]
    statement_of_identity
end

def get_product_name(dsld_info)
    # id = get_id_from_result(dsld_info)
    # result = get_dsld_lable_info(id)
    product_name = dsld_info["Product_Name"]
    product_name
end

def get_suggested_use(dsld_info)
    # result = complete_dsld_api_result(get_dsld_id)
    suggested_use = dsld_info["Suggested_Use"]
    suggested_use
end

def get_statments(dsld_info)
##### FUNCTION NOT FINISHED DETAILS COME BACK BUT ARE MIXED ##########
    result = complete_dsld_api_result(get_dsld_id)
    statements = []
    result["statements"].each do |statement|
        puts(statement["Statement"])
    end
end

new_upc = add_spacing_to_upc("030768032682")
# print(new_upc, "this is the new upc")

result = get_dsld_api_result("0 30768 03268 2")
# print(result, "HERE IS THE RESULT")
get_id_from_result(result)
# print(result, "this is result")
# dsld_hash = get_dsld_lable_info(result)
# print(dsld_hash)

# print(statements)



# result.each do |info|
#     puts info
# end