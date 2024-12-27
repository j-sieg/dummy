module Users
  class MonthlyExpensesBreakdownController < ApplicationController
    def index
    end

    def show
      date = Date.parse(params[:date])
      breakdown = ExpensesBreakdown.new(user: current_user, date: date)

      render locals: {
        date: date,
        expenses: breakdown.daily_expenses,
        misc_total: breakdown.misc_total,
        monthly_recurring_total: breakdown.monthly_recurring_total,
        total_for_month: breakdown.total_for_month,
        no_expenses_this_month: breakdown.no_expenses_this_month?
      }
    end
  end
end