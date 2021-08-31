# frozen_string_literal: true

require_relative 'db'

class ConnectionHandler
  attr_reader :connections

  def initialize(
    messages: Message,
    send_message_action: SendMessageAction.new(handler: self, messages: Message)
  )
    @connections = Set.new
    @messages = messages
    @send_message_action = send_message_action
  end

  def connected(connection)
    connections << connection

    messages.all.each do |message|
      connection.send(message.contents)
    end
  end

  def received(connection, data)
    send_message_action.call(connection: connection, data: data)
  end

  def disconnected(connection)
    connections.delete(connection)
  end

  private

  attr_reader :messages, :send_message_action

  def send_to_all(data)
    connections.each do |connection|
      connection.send(data)
    end
  end
end
