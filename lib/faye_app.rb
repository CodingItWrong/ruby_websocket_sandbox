## frozen_string_literal: true

require 'faye/websocket'
require 'pry'

Handler = ConnectionHandler.new

FayeApp = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    ws.send('Connected to Faye')

    # note that Faye::WebSocket already matches the contract of a connection,
    # so it doesn't need to be adapted.
    Handler.connected(ws)

    ws.on :message do |event|
      puts "Faye received: #{event.data}"
      Handler.received(ws, event.data)
    end

    ws.on :close do |event|
      Handler.disconnected(ws)
    end

    # Return async Rack response
    ws.rack_response

  else
    # Normal HTTP request
    [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
  end
end
