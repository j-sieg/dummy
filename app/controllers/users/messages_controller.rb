module Users
  class MessagesController < ApplicationController
    include ConversationScoped

    def create
      result = MessageCreator.new.create_message(@conversation, current_user, message_params)
      if result.created?
        head :ok
      else
        head :unprocessable_entity
      end
    end

    private

    def message_params
      params.require(:message).permit(:body)
    end
  end
end