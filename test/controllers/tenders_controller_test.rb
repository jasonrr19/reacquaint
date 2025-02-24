require "test_helper"

class TendersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tenders_index_url
    assert_response :success
  end

  test "should get show" do
    get tenders_show_url
    assert_response :success
  end

  test "should get new" do
    get tenders_new_url
    assert_response :success
  end

  test "should get update" do
    get tenders_update_url
    assert_response :success
  end
end
