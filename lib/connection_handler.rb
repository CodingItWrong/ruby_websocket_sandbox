# frozen_string_literal: true

require_relative 'message'

class ConnectionHandler
  def initialize
    @connections = Set.new
  end

  def connected(connection)
    connections << connection

    Message.all.each do |message|
      connection.send(message.contents)
    end
  end

  def received(_connection, data)
    puts "Faye received: #{data}"
    Message.create!(contents: data)
    send_all(data)
  end

  def disconnected(connection)
    connections.delete(connection)
  end

  private

  attr_reader :connections

  def send_all(data)
    connections.each do |connection|
      connection.send("Response from Faye: #{data}")
    end
  end
end
