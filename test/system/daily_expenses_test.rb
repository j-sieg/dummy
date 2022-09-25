require "application_system_test_case"

class DailyExpensesTest < ApplicationSystemTestCase
  test "date switching in #index" do
    login_as(users(:james))

    visit daily_expenses_url(date: "1999-11-27")

    within "table[class='calendar--table']" do
      assert_selector "td[class='calendar--cell today']", text: "27"
      
      # Switch to the 16th of November
      find("td", text: "16").click
      assert_selector "td[class='calendar--cell today']", text: "16"
      assert_no_selector "td[class='calendar--cell today']", text: "27"

      # Switch to the 24th of November
      find("td", text: "24").click
      assert_selector "td[class='calendar--cell today']", text: "24"
      assert_no_selector "td[class='calendar--cell today']", text: "16"
    end
  end
end
