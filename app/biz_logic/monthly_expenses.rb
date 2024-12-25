class MonthlyExpenses
  attr_reader :user, :date

  def initialize(user:, date: Date.current)
    @user = user
    @date = date
  end

  def dates_with_expenses
    user.expenses.where(date: date_range).select(:date).distinct.pluck(:date)
  end

  def daily_expenses
    user.expenses.where(date: date_range)
  end

  def total_for_month
    user.expenses.where(date: date_range).sum(:amount) / 100.0
  end

  def no_expenses_this_month?
    !daily_expenses.exists?
  end

  private

  def date_range
    @date_range ||= date.beginning_of_month..date.end_of_month
  end
end
