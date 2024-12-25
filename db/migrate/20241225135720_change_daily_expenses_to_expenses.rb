class ChangeDailyExpensesToExpenses < ActiveRecord::Migration[8.0]
  def change
    rename_table :daily_expenses, :expenses
  end
end
