class DailyExpensesFilter
  attr_reader :user, :date

  def initialize(user:, date: Date.current)
    @user = user
    @date = date
  end

  def results
    user.daily_expenses.where(date: date)
  end
end
