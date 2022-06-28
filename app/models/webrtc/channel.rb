class Webrtc::Channel < ApplicationRecord
  validates :name, presence: true
end
