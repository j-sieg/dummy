class ConversationParticipant < ApplicationRecord
  belongs_to :conversation
  belongs_to :participant, class_name: "User"
end
