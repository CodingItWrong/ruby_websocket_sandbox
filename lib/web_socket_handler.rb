# frozen_string_literal: true

require_relative 'message'

class WebSocketHandler
  def initialize
    @connections = Set.new
  end

  def connected(ws)
    connections << ws

    ws.send('Connected to Faye')

    Message.all.each do |message|
      ws.send(message.contents)
    end

    ws.on :message do |event|
      received(event.data)
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      connections.delete(ws)
    end
  end

  private

  attr_reader :connections

  def received(data)
    puts "Faye received: #{data}"
    Message.create!(contents: data)
    send_all(data)
  end

  def send_all(data)
    connections.each do |connection|
      connection.send("Response from Faye: #{data}")
    end
  end
end
