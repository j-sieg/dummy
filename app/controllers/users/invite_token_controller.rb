module Users
  class InviteTokenController < ApplicationController
    def update
      current_user.invite_token.regenerate_token
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to settings_url, alert: "Updated your invite token!" }
      end
    end
  end
end