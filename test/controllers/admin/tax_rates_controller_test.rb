require "test_helper"

class Admin::TaxRatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_tax_rates_index_url
    assert_response :success
  end

  test "should get edit" do
    get admin_tax_rates_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_tax_rates_update_url
    assert_response :success
  end
end
