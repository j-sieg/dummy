class ExpensesBreakdown
  attr_reader :user, :date

  def initialize(user:, date: Date.current)
    @user = user
    @date = date
  end

  def dates_with_expenses
    scoped_expenses.select(:date).distinct.pluck(:date)
  end

  def daily_expenses
    scoped_expenses
  end

  def misc_total
    scoped_expenses.where(recurring: nil).sum(:amount) / 100.0
  end

  def monthly_recurring_total
    scoped_expenses.monthly.sum(:amount) / 100.0
  end

  def total_for_month
    scoped_expenses.sum(:amount) / 100.0
  end

  def no_expenses_this_month?
    !daily_expenses.exists?
  end

  def maybe_create_monthly_expenses
    return unless date.future?

    distinct_monthly_expenses.each do |virtual_expense|
      unless user.expenses.monthly.where(date: date_range).exists?(purpose: virtual_expense.purpose)
        # Ensure the day is valid for the month
        new_date =
          begin
            virtual_expense.date.change(month: date.month, year: date.year)
          rescue Date::Error
            virtual_expense.date.change(day: date.end_of_month.day, month: date.month, year: date.year)
          end

        record = user.expenses.monthly.create(
          purpose: virtual_expense.purpose,
          amount: virtual_expense.amount.to_i / 100,
          date: new_date,
          recurring: "monthly"
        )
      end
    end
  end

  private

  def scoped_expenses
    user.expenses.where(date: date_range, disabled_at: nil)
  end

  def distinct_monthly_expenses
    user.expenses.monthly.select("purpose, AVG(amount) as amount, MAX(date) as date").group("purpose")
  end

  def date_range
    @date_range ||= date.beginning_of_month..date.end_of_month
  end
end