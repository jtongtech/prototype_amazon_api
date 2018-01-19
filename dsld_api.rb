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

def get_statements_of_formulation(dsld_info)
    formulation_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "Formulation"
            formulation_statments << statement["Statement"]
        end
    end
    # puts(formulation_statments)
    formulation_statments
end

def get_statements_of_other(dsld_info)
    other_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "Other"
            other_statments << statement["Statement"]
        end
    end
    # puts(other_statments)
    other_statments
end

def get_statements_of_recommended(dsld_info)
    recommended_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "Suggested/Recommended/Usage/Directions"
            recommended_statments << statement["Statement"]
        end
    end
    # puts(recommended_statments)
    recommended_statments
end

def get_statements_of_disclaimer_statement(dsld_info)
    disclaimer_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "FDA Disclaimer Statement"
            disclaimer_statments << statement["Statement"]
        end
    end
    # puts(disclaimer_statments)
    disclaimer_statments
end

def get_statements_of_identity_statement(dsld_info)
    identity_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "FDA Statement of Identity"
            identity_statments << statement["Statement"]
        end
    end
    # puts(identity_statments)
    identity_statments
end

def get_statements_of_precautions(dsld_info)
    precautions_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "Precautions"
            precautions_statments << statement["Statement"]
        end
    end
    # puts(precautions_statments)
    precautions_statments
end

def get_statements_of_prod_specific_info(dsld_info)
    prod_specific_info_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "Product Specific Information"
            prod_specific_info_statments << statement["Statement"]
        end
    end
    # puts(prod_specific_info_statments)
    prod_specific_info_statments
end

def get_statements_of_seals_and_symbols(dsld_info)
    seals_and_symbols_statments = []
    dsld_info["statements"].each do |statement|
        if statement["Statement_Type"] == "Seals/Symbols"
            seals_and_symbols_statments << statement["Statement"]
        end
    end
    # puts(seals_and_symbols_statments)
    seals_and_symbols_statments
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
    # result = complete_dsld_api_result(get_dsld_id)
    statements = []
    # puts(dsld_info["statements"])
    dsld_info["statements"].each do |statement|
        statements << statement["Statement"]
         puts(statement["Statement_Type"])
        # puts(statement["Statement"])
    end
    statements
end

def get_ingredients(dsld_info)
    ingredients = []
    dsld_info["ingredients"].each do |ingredient|
        ingredients << [ingredient["Dietary_Ingredient_Synonym_Source"], ingredient["Amount_Per_Serving"], ingredient["Amount_Serving_Unit"]]
        # puts(ingredient["Dietary_Ingredient_Synonym_Source"])
    end
    ingredients
end

# new_upc = add_spacing_to_upc("719985300400")
new_upc = add_spacing_to_upc("733739003409")
# new_upc = add_spacing_to_upc("037000741343")
# print(new_upc, "this is the new upc")

result = get_dsld_api_result(new_upc)
# print(result, "HERE IS THE RESULT")
id = get_id_from_result(result)
# print(result, "this is result")
dsld_hash = get_dsld_lable_info(id)
# print(dsld_hash)
statements = get_statments(dsld_hash)
suggested_use = get_suggested_use(dsld_hash)
product_name = get_product_name(dsld_hash)
statements_of_formulation = get_statements_of_formulation(dsld_hash)
statements_of_other = get_statements_of_other(dsld_hash)
statements_of_recommended = get_statements_of_recommended(dsld_hash)
statements_of_disclaimer_statement = get_statements_of_disclaimer_statement(dsld_hash)
statements_of_identity = get_statements_of_identity_statement(dsld_hash)
statements_of_precautions = get_statements_of_precautions(dsld_hash)
statements_of_prod_specific_info = get_statements_of_prod_specific_info(dsld_hash)
statements_of_seals_and_symbols = get_statements_of_seals_and_symbols(dsld_hash)
ingredient = get_ingredients(dsld_hash)
# puts(suggested_use, "<----- SUGGESTED USE")
# puts(product_name, "<----- PRODUCT TITLE")
# puts(statement_of_identity, "<----- STATEMENT OF IDENTITY")
# puts(ingredient, "<----- THESE ARE INGREDIENTS")
