module ConversationScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_conversation
  end

  private

  def set_conversation
    @conversation = Conversation.includes(:conversation_participants).where({conversation_participants: {participant: current_user}}).find(params[:conversation_id])
  end
end