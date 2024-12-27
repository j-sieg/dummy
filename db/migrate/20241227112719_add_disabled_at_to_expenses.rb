class AddDisabledAtToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :disabled_at, :timestamp
  end
end
