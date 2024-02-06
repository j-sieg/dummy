require "test_helper"

class Conversation::MessagesReaderTest < ActiveSupport::TestCase
  test "#mark_all_as_read! creates a message receipt on the latest message" do
    convo = conversations(:cars)
    reader = users(:josh)
    writer = users(:james)

    old_msg = Message.create!(conversation: convo, sender: writer, body: "This is #1")
    new_msg = Message.create!(conversation: convo, sender: writer, body: "This is #2")
    messages_reader = Conversation::MessagesReader.new(convo, reader)

    assert_difference ->{ convo.message_receipts.count } => 1,
      ->{ new_msg.readers.count } => 1,
      ->{ old_msg.readers.count } => 0 do
      messages_reader.mark_all_as_read!
    end
  end
end