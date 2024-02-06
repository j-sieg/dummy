require "test_helper"

class Conversation::MessageReceiptTest < ActiveSupport::TestCase
  # This test actually tests the behavior of the triggers
  # created in the database.
  test "keeps the user to one message receipt per conversation" do
    # THIS IS THE CONVERSATION ABOUT CARS
    cars_conversation = conversations(:cars)
    reader = users(:josh)
    writer = users(:james)

    message_1 = Message.create!(conversation: cars_conversation, sender: writer, body: "This is #1")
    message_2 = Message.create!(conversation: cars_conversation, sender: writer, body: "This is #2")

    # Create a message receipt
    Conversation::MessageReceipt.create!(user: reader, conversation: cars_conversation, message: message_1)

    # Create another one
    Conversation::MessageReceipt.create!(user: reader, conversation: cars_conversation, message: message_2)
    assert_equal 1, cars_conversation.message_receipts.where(user: reader).count

    # THIS IS THE CONVERSATION ABOUT CATS
    cats_conversation = conversations(:cats)

    message_1 = Message.create!(conversation: cats_conversation, sender: writer, body: "This is #1")
    message_2 = Message.create!(conversation: cats_conversation, sender: writer, body: "This is #2")

    # Create a message receipt
    Conversation::MessageReceipt.create!(user: reader, conversation: cats_conversation, message: message_1)

    # Create another one
    Conversation::MessageReceipt.create!(user: reader, conversation: cats_conversation, message: message_2)
    assert_equal 1, cats_conversation.message_receipts.where(user: reader).count

    # The total `Conversation::MessageReceipt`
    assert_equal 2, Conversation::MessageReceipt.where(user: reader).count
  end
end