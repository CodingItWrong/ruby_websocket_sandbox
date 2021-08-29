# frozen_string_literal: true

require_relative 'db'
require_relative 'message'

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

  def received(_connection, data)
    messages.create!(contents: data)
    send_all(data)
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
