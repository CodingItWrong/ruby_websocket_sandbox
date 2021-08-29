## frozen_string_literal: true

require 'faye/websocket'
require 'pry'
require_relative 'db'
require_relative 'connection_handler'

Handler = ConnectionHandler.new

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    ws.send('Connected to Faye')
    Handler.connected(ws)

    # Return async Rack response
    ws.rack_response

  else
    # Normal HTTP request
    [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
  end
end
