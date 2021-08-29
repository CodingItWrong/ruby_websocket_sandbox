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

    connection.on :message do |event|
      received(event.data)
    end

    connection.on :close do |event|
      p [:close, event.code, event.reason]
      connections.delete(connection)
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
