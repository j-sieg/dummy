class MonthlyExpenses
  attr_reader :user, :date

  def initialize(user:, date: Date.current)
    @user = user
    @date = date
  end

  def dates_with_expenses
    user.daily_expenses.where(date: date_range).pluck(:date).uniq
  end

  def daily_expenses
    user.daily_expenses.where(date: date_range)
  end

  def total_for_month
    user.daily_expenses.where(date: date_range).sum(:amount) / 100.0
  end

  def no_expenses_this_month?
    !daily_expenses.exists?
  end

  private

  def date_range
    @date_range ||= date.beginning_of_month..date.end_of_month
  end
end
