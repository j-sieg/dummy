class CreateConversationParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :conversation_participants do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end

    # Note: Had to rename the index name Rails creates by default
    # since it exceeds the max character limit (63).
    add_index :conversation_participants, [:conversation_id, :participant_id], unique: true,name: "index_conversation_participants_on_conversation_and_participant"
  end
end
