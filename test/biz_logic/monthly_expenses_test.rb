require "test_helper"

class MonthlyExpensesTest < ActiveSupport::TestCase
  test "#total_for_month sums up the daily expenses for the month" do
    object = MonthlyExpenses.new(user: users(:james), date: Date.parse("2022-08-09"))
    assert_equal 7300.97, object.total_for_month
  end
end