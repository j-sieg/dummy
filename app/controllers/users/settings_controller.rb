module Users
  class SettingsController < ApplicationController
    def index
      render locals: {active_sessions: current_user.tokens}
    end
  end
end
