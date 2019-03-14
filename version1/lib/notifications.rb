require 'redis'
require 'json'


module Notifications
  @@redis = Redis.new

  SOUNDS = {
    :trumpet => "/sound.mp3",
    :lmfao => "/sexy.mp3",
    :siren => "/siren.mp3",
    :blip => "/blip.mp3"
  }


  def Notifications.send(message, extra={})
    payload = JSON({
      :data => message
    }.merge(extra))
    @@redis.publish('channel', payload)
  end
end
