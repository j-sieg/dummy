class CreateUserInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :user_invites do |t|
      t.references :inviter, foreign_key: {to_table: :users}
      t.references :invited, foreign_key: {to_table: :users}, index: {unique: true}
      t.integer :level, null: false, default: 0

      t.timestamps
    end
  end
end
