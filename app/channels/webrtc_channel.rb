class WebrtcChannel < ApplicationCable::Channel
  def subscribed
    @stream_name = params[:name]
    stream_for @stream_name
    broadcast_joined
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    broadcast_left
  end

  def broadcast_joined
    WebrtcChannel.broadcast_to(@stream_name, {
      peer_id: current_user.id,
      event_name: "peer_joined",
      message: "#{current_user.email} just joined!"
    })
  end

  def broadcast_left
    WebrtcChannel.broadcast_to(@stream_name, {
      peer_id: current_user.id,
      event_name: "peer_left",
      message: "#{current_user.email} just left!"
    })
  end

  def signal(data)
    WebrtcChannel.broadcast_to(@stream_name, {
      peer_id: current_user.id,
      event_name: "signal",
      data: data
    })
  end
end
