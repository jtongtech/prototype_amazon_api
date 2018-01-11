require "minitest/autorun"
require 'open-uri'
require 'nokogiri'
require_relative 'mock_results.rb'
require_relative "../api_upc_db.rb"
load "../local_env.rb" if File.exist?("../local_env.rb")

class TestNutritionixApi < Minitest::Test

    def test_error_check_passes_with_good_result
        data_hash = NUTR_RESULT
        assert_nil(error_check_nutritionix(data_hash))
    end

    def test_error_check_returns_error_message_with_not_found
        data_hash = BAD_NUTR_RESULT
        assert_equal("resource not found", error_check_nutritionix(data_hash))
    end

    def test_error_check_passes_with_good_result
        data_hash = NUTR_RESULT
        assert_equal("https://d1r9wva3zcpswd.cloudfront.net/54998da0e5da8d163abaf118.jpeg", get_nutritionix_large_images(data_hash))
    end

    def test_error_check_passes_with_good_result
        data_hash = NUTR_RESULT
        assert_equal("EAS Whey Protein, Chocolate", get_nutritionix_product_title(data_hash))
    end

end