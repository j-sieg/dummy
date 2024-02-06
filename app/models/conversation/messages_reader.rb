class Conversation::MessagesReader
  attr_reader :conversation, :user

  def initialize(conversation, user)
    @conversation = conversation
    @user = user
  end

  def mark_all_as_read!
    last_message = conversation.messages.last
    @conversation.message_receipts.create!(
      user: @user,
      message: last_message
    )
  end

  def read_message!(message)
    @conversation.message_receipts.create!(
      user: @user,
      message: message
    )
  end
end