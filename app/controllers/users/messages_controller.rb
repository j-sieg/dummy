module Users
  class MessagesController < ApplicationController
    include ConversationScoped

    def create
      MessageCreator.new.create_message(@conversation, current_user, message_params)
    end

    private

    def message_params
      params.require(:message).permit(:body)
    end
  end
end