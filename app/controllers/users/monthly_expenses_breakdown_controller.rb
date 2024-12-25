module Users
  class MonthlyExpensesBreakdownController < ApplicationController
    def index
    end

    def show
      date = Date.parse(params[:date])
      monthly_expenses = MonthlyExpenses.new(user: current_user, date: date)

      render locals: {
        date: date,
        expenses: monthly_expenses.daily_expenses,
        misc_total: monthly_expenses.misc_total,
        monthly_recurring_total: monthly_expenses.monthly_recurring_total,
        total_for_month: monthly_expenses.total_for_month,
        no_expenses_this_month: monthly_expenses.no_expenses_this_month?
      }
    end
  end
end