module Users
  class ConversationsController < ApplicationController
    def index
      conversations = Conversation.includes(:conversation_participants).where({conversation_participants: {participant: current_user}})
      render locals: {conversations: conversations}
    end

    def show
      conversation = Conversation.includes(:conversation_participants).where({conversation_participants: {participant: current_user}}).find(params[:id])
      messages = conversation.messages.includes(:sender)
      render layout: "conversations", locals: {conversation: conversation, messages: messages}
    end
  end
end
