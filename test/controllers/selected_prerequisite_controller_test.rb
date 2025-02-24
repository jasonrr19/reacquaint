require "test_helper"

class SelectedPrerequisiteControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get selected_prerequisite_edit_url
    assert_response :success
  end

  test "should get update" do
    get selected_prerequisite_update_url
    assert_response :success
  end
end
