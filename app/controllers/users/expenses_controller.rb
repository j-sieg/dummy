module Users
  class ExpensesController < ApplicationController
    before_action :set_date_viewed

    def index
      new_expense = current_user.expenses.new
      date_scoped_expenses = current_user.expenses.where(date: @date_viewed, disabled_at: nil)

      obj = ExpensesBreakdown.new(user: current_user, date: @date_viewed)
      obj.maybe_create_monthly_expenses
      dates_with_expenses = obj.dates_with_expenses

      render locals: {date_scoped_expenses:, new_expense:, dates_with_expenses:}
    end

    def show
      expense = current_user.expenses.find(params[:id])
      render locals: {expense: expense}
    end

    def create
      expense = current_user.expenses.new(expense_params)

      if expense.save
        redirect_to expenses_url(date: expense.date), notice: "Logged"
      else
        redirect_to expenses_url(date: expense.date), alert: "Failed to log the expense"
      end
    end

    def edit
      expense = current_user.expenses.recurring.find(params[:id])
      render locals: {expense: expense}
    end

    def update
      expense = current_user.expenses.recurring.find(params[:id])

      expense.update(update_params)
      render locals: {expense: expense}
    end

    def destroy
      expense = current_user.expenses.find(params[:id])
      result = ExpenseDestroyer.new.destroy(expense, params[:destroy_option])

      respond_to do |format|
        format.turbo_stream { render locals: {expense: result.expense} }
        format.html { redirect_to expenses_url, notice: "Successfully delete the expense" }
      end
    end

    private

    def expense_params
      params.require(:expense).permit(:date, :purpose, :amount, :recurring)
    end

    def update_params
      params.require(:expense).permit(:amount)
    end

    def set_date_viewed
      @date_viewed = Date.parse(params[:date])
    rescue
      @date_viewed = Date.current
    end
  end
end
