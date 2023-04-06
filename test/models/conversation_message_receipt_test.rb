require "test_helper"

class ConversationMessageReceiptTest < ActiveSupport::TestCase
  test "keeps the user to one message receipt per conversation" do
    convo = conversations(:cars)
    reader = users(:josh)
    writer = users(:james)

    message_1 = Message.create!(conversation: convo, sender: writer, body: "This is #1")
    message_2 = Message.create!(conversation: convo, sender: writer, body: "This is #2")

    # Create a message receipt
    ConversationMessageReceipt.create!(user: reader, conversation: convo, message: message_1)

    # Create another one
    ConversationMessageReceipt.create!(user: reader, conversation: convo, message: message_2)
    assert_equal 1, ConversationMessageReceipt.where(user: reader, conversation: convo).count
  end
end