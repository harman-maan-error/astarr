require "test_helper"

class Admin::ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_reviews_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_reviews_show_url
    assert_response :success
  end

  test "should get approve" do
    get admin_reviews_approve_url
    assert_response :success
  end

  test "should get reject" do
    get admin_reviews_reject_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_reviews_destroy_url
    assert_response :success
  end
end
