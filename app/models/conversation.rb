class Conversation < ApplicationRecord
  has_many :conversation_participants
  has_many :participants, through: :conversation_participants

  has_many :messages
end