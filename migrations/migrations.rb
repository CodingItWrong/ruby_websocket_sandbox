# frozen_string_literal: true

# TODO: dynamically import all migrations and provide a way to run all

require_relative '00001_create_messages_table.rb'

class Migrations
  class << self
    delegate :migrate, to: CreateMessagesTable
  end
end
