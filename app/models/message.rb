class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :conversation

  validates :body, presence: true

  def pakita
    broadcast_append_to(dom_id(self.conversation), target: dom_id(self.conversation, :messages), partial: "users/messages/message", locals: {message: self})
  end

  def pakita_later
    broadcast_append_to(dom_id(self.conversation), target: dom_id(self.conversation, :messages), partial: "users/messages/message", locals: {message: self})
  end
end
