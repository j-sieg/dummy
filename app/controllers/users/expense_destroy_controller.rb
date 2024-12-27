module Users
  class ExpenseDestroyController < ApplicationController
    def show
      expense = current_user.expenses.find(params[:id])
      render locals: {expense: expense}
    end
  end
end