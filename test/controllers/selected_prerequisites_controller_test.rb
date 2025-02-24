require "test_helper"

class SelectedPrerequisitesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get selected_prerequisites_edit_url
    assert_response :success
  end

  test "should get update" do
    get selected_prerequisites_update_url
    assert_response :success
  end
end
