class MonthlyExpenses
  attr_reader :user, :date

  def initialize(user:, date: Date.current)
    @user = user
    @date = date
  end

  def dates_with_expenses
    date_range = (date.beginning_of_month..date.end_of_month)
    user.daily_expenses.where(date: date_range).pluck(:date).uniq
  end
end
