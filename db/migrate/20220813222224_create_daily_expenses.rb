class CreateDailyExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :amount, default: 0
      t.text :purpose

      t.timestamps
    end
  end
end
