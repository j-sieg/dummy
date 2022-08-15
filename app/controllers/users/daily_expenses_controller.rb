module Users
  class DailyExpensesController < ApplicationController
    before_action :set_date_viewed

    def index
      daily_expense = current_user.daily_expenses.new
      daily_expenses = DailyExpensesFilter.new(user: current_user, date: @date_viewed).results.load
      dates_with_expenses = MonthlyExpenses.new(user: current_user, date: @date_viewed).dates_with_expenses

      render locals: {daily_expenses:, daily_expense:, dates_with_expenses:}
    end

    def create
      daily_expense = current_user.daily_expenses.new(daily_expense_params)

      if daily_expense.save
        redirect_to daily_expenses_url(date: daily_expense.date), notice: "Logged"
      else
        redirect_to daily_expenses_url(date: daily_expense.date), alert: "Failed to log the expense"
      end
    end

    private

    def daily_expense_params
      params.require(:daily_expense).permit(:date, :purpose, :amount)
    end

    def set_date_viewed
      @date_viewed = Date.parse(params[:date])
    rescue
      @date_viewed = Date.current
    end
  end
end
