class CreateConversationMessageReceipts < ActiveRecord::Migration[7.0]
  def up
    create_table :conversation_message_receipts do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :read_at, null: false
    end

    execute <<-SQL
      CREATE FUNCTION delete_previous_read_receipts() RETURNS TRIGGER AS $$
      BEGIN
        DELETE FROM conversation_message_receipts 
        WHERE conversation_id = NEW.conversation_id
        AND user_id = NEW.user_id
        AND read_at < NEW.read_at;
        RETURN NULL;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER delete_message_receipts AFTER INSERT ON conversation_message_receipts 
      FOR EACH ROW
      EXECUTE FUNCTION delete_previous_read_receipts();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER delete_message_receipts ON conversation_message_receipts;
      DROP FUNCTION delete_previous_read_receipts;
    SQL

    drop_table :conversation_message_receipts
  end
end
