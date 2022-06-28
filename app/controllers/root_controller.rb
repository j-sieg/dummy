class RootController < ApplicationController
  include UserAuthentication

  def index
    render locals: {channels: Webrtc::Channel.all}
  end
end
