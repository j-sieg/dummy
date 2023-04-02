class UseTimestamptzOnAllTables < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :created_at, :timestamptz, null: false
    change_column :users, :updated_at, :timestamptz, null: false
    change_column :users, :confirmed_at, :timestamptz

    change_column :user_tokens, :created_at, :timestamptz, null: false
  end

  def down
    change_column :users, :created_at, :timestamp, null: false
    change_column :users, :updated_at, :timestamp, null: false
    change_column :users, :confirmed_at, :timestamp

    change_column :user_tokens, :created_at, :timestamp, null: false
  end
end
