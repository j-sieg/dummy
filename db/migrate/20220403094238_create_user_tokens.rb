class CreateUserTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tokens do |t|
      t.references :user, foreign_key: true, null: false
      t.binary :token, null: false
      t.string :context, null: false
      t.string :sent_to
      t.datetime :created_at, null: false
    end

    add_index :user_tokens, [:token, :context], unique: true
  end
end
