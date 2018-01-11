require 'uri'
require 'net/http'
require 'openssl'
require 'base64'
require 'open-uri'
require 'json'
# ​
dsld_id = ""
spaced_upc = "0%2037000%2074134%203"
get_dsld_id = URI("http://www.dsld.nlm.nih.gov/dsld/api/qsearch?searchterm=" + spaced_upc)
get_dsld_info = URI("http://www.dsld.nlm.nih.gov/dsld/api/label/" + dsld_id)
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
    dsld_data_hash

end

def complete_dsld_api_result(get_dsld_id)
    dsld_id = dsld_api(get_dsld_id)["foundin_05_anyhwere"]["products"][0]["ID"]
    puts dsld_id
    dsld_info = dsld_api(URI("http://www.dsld.nlm.nih.gov/dsld/api/label/" + dsld_id))
    puts dsld_info
end

complete_dsld_api_result(get_dsld_id)