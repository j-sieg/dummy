require "test_helper"

class MonthlyExpensesTest < ActiveSupport::TestCase
  test "#total_for_month sums up the daily expenses for the month" do
    object = MonthlyExpenses.new(user: users(:james), date: Date.parse("2022-08-09"))
    assert_equal 17300.97, object.total_for_month
  end

  test "#misc_total sums up the miscellaneous expenses for the month" do
    object = MonthlyExpenses.new(user: users(:james), date: Date.parse("2022-08-09"))
    assert_equal 5500.97, object.misc_total
  end

  test "#monthly_recurring_total sums up the monthly recurring expenses for the month" do
    object = MonthlyExpenses.new(user: users(:james), date: Date.parse("2022-08-09"))
    assert_equal 11800, object.monthly_recurring_total
  end

  test "#maybe_create_monthly_expenses when the 'date' is out of bounds for the current month" do
    user = users(:james)

    travel_to Date.parse("2023-01-01") do
      object = MonthlyExpenses.new(user: user, date: Date.parse("2023-02-01"))

      assert_difference "user.expenses.monthly.count", 2 do
        object.maybe_create_monthly_expenses
      end

      # august_electricity is due on the 30th of every month but Feb only has 28 days
      assert user.expenses.monthly.find_by(purpose: "Electricity", date: "2023-02-28")
      assert user.expenses.monthly.find_by(purpose: "wifi", date: "2023-02-17")

      # Does not create duplicates
      object = MonthlyExpenses.new(user: user, date: Date.parse("2023-02-01"))
      assert_no_difference "user.expenses.monthly.count" do
        object.maybe_create_monthly_expenses
      end
    end
  end

  test "#maybe_create_monthly_expenses does not create dates when the date given is in the past" do
    user = users(:james)
    travel_to Date.parse("2023-02-01") do
      object = MonthlyExpenses.new(user: , date: Date.parse("2023-01-01"))

      assert_no_difference "user.expenses.monthly.count", 2 do
        object.maybe_create_monthly_expenses
      end
    end
  end
end