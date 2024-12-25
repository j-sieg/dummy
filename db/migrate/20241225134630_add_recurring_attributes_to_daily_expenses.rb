class AddRecurringAttributesToDailyExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :daily_expenses, :recurring, :string
  end
end
