require 'em-websocket'
require 'em-hiredis'


module Websocket
  def Websocket.run
    EventMachine.run {

      @@clients = []

      subscriber = EM::Hiredis.connect
      subscriber.subscribe('channel')

      subscriber.on(:message) { |channel, message|
        @@clients.each do |ws|
          message.force_encoding("UTF-8")
          ws.send(message)
        end
      }

      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
        ws.onopen {
          @@clients << ws
        }

        ws.onclose {}

        ws.onmessage {|msg|}
      end

    }
  end
end
