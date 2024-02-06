class MessageCreator
  delegate :dom_id, to: ActionView::RecordIdentifier

  def create_message(conversation, user, msg_params)
    msg_params.merge!({conversation: conversation, sender: user})
    message = Message.new(msg_params)

    if message.save
      message.broadcast_append_to(
        dom_id(conversation),
        target: dom_id(conversation, :messages),
        partial: "users/messages/message",
        locals: {message: message}
      )
      Result.new(created: true, message:)
    else
      Result.new(created: false, message:)
    end
  end

  # We assume that the user who recently sent a message
  # has read all the messages in the conversation.
  # Maybe this should be a trigger?
  def delete_all_read_receipts(conversation, user)
    conversation.message_receipts(user: user).delete_all
  end

  class Result
    attr_reader :message

    def initialize(created:, message: nil)
      @created = created
      @message = message
    end

    def created?
      @created
    end
  end
end
