require 'faye/websocket'
require_relative 'db'
require_relative 'message'

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    ws.send('Connected to Faye')

    Message.all.each do |message|
      ws.send(message.contents)
    end

    ws.on :message do |event|
      contents = event.data
      puts "Faye received: #{contents}"
      ws.send("Response from Faye: #{contents}")
      Message.create!(contents: contents)
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end

    # Return async Rack response
    ws.rack_response

  else
    # Normal HTTP request
    [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
  end
end
