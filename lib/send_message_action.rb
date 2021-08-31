# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

class SendMessageAction
  def initialize(handler:, messages:)
    @handler = handler
    @messages = messages
  end

  def call(connection:, data:)
    message = messages.create!(contents: data)
    send_to_all(data)
  rescue => e
    connection.send(e.message)
  end

  private

  attr_reader :handler, :messages
  delegate :connections, to: :handler

  def send_to_all(data)
    connections.each do |connection|
      connection.send(data)
    end
  end
end
