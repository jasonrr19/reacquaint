require "test_helper"

class CompatibleResponsesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get compatible_responses_edit_url
    assert_response :success
  end

  test "should get update" do
    get compatible_responses_update_url
    assert_response :success
  end
end
