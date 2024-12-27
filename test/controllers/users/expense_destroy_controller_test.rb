require "test_helper"

class Users::ExpenseDestroyControllerTest < ActionDispatch::IntegrationTest
  test "doesn't crash" do
    user_log_in_as(users(:james))
    get expense_destroy_path(expenses(:august_grab))
    assert_response :success
  end
end
