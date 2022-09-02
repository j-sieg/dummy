require "test_helper"

class DailyExpenseTest < ActiveSupport::TestCase
  test "converts the amount to cents" do
    de = DailyExpense.new(amount: 500.97)
    assert_equal 50097, de.amount
    assert_equal 500.97, de.amount_from_cents
  end
end
