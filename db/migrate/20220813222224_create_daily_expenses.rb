class CreateDailyExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :expense, default: 0

      t.timestamps
    end
  end
end