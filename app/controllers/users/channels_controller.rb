module Users
  class ChannelsController < ApplicationController
    def show
      channel = Webrtc::Channel.find(params[:id])
      render locals: {channel: channel}
    end
  end
end
