require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get pages_about_url
    assert_response :success
  end

  test "should get contact" do
    get pages_contact_url
    assert_response :success
  end

  test "should get shipping" do
    get pages_shipping_url
    assert_response :success
  end

  test "should get returns" do
    get pages_returns_url
    assert_response :success
  end
end
