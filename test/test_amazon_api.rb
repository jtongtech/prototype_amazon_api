require "minitest/autorun"
require 'open-uri'
require 'nokogiri'
require_relative 'mock_amazon_results.rb'
require_relative "../api.rb"
load "../local_env.rb" if File.exist?("../local_env.rb")

class TestAmazonApi < Minitest::Test

    def test_error_check_passes_with_good_result
        html_info = HTML_RESULT
        assert_equal("", error_check(html_info))
    end

    def test_error_check_fails_with_not_found_result
        html_info = AMAZON_NOT_FOUND_RESULT
        assert_equal("678829250663 is not a valid value for ItemId. Please change this value and retry your request.", error_check(html_info))
    end

    def test_large_image_function_pulls_correct_images
        html_info = HTML_RESULT
        large_img_array = MOCK_LARGE_IMAGE
        assert_equal(large_img_array, get_large_images(html_info))
    end

    def test_large_image_function_does_not_fail_if_not_present
        html_info = AMAZON_NOT_FOUND_RESULT
        assert_equal([], get_large_images(html_info))
    end

    def test_get_product_title_returns_title
        html_info = HTML_RESULT
        assert_equal("TruNature Ginko Biloba with Vinpocetine, 120 mg, 300-softgels Bottle", get_product_title(html_info))
    end

    def test_get_product_price_returns_price
        html_info = HTML_RESULT
        assert_equal("$26.41", get_product_price(html_info))
    end

end