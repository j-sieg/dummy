class ConversationMessageReceipt < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  belongs_to :message

  before_create do
    self.read_at = Time.current
  end
end