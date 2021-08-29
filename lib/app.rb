require 'faye/websocket'
require_relative 'db'
require_relative 'message'
require 'pry'

$connections = Set.new

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    $connections << ws

    ws.send('Connected to Faye')

    Message.all.each do |message|
      ws.send(message.contents)
    end

    ws.on :message do |event|
      contents = event.data
      puts "Faye received: #{contents}"
      Message.create!(contents: contents)

      $connections.each do |connection|
        connection.send("Response from Faye: #{contents}")
      end
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      $connections.delete(ws)
      ws = nil
    end

    # Return async Rack response
    ws.rack_response

  else
    # Normal HTTP request
    [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
  end
end
