module Users
  class MonthlyExpensesBreakdownController < ApplicationController
    def index
    end

    def show
      date = Date.parse(params[:date])
      @monthly_expenses = MonthlyExpenses.new(user: current_user, date: date)
      render locals: {
        date: date,
        expenses: @monthly_expenses.daily_expenses,
        total_for_month: @monthly_expenses.total_for_month
      }
    end
  end
end