# frozen_string_literal: true

require_relative 'db'

class ConnectionHandler
  def initialize(messages: Message)
    @connections = Set.new
    @messages = messages
  end

  def connected(connection)
    connections << connection

    messages.all.each do |message|
      connection.send(message.contents)
    end
  end

  def received(connection, data)
    message = messages.create!(contents: data)
    send_all(data)
  rescue => e
    connection.send(e.message)
  end

  def disconnected(connection)
    connections.delete(connection)
  end

  private

  attr_reader :connections, :messages

  def send_all(data)
    connections.each do |connection|
      connection.send("Response: #{data}")
    end
  end
end
