# frozen_string_literal: true

# TODO: dynamically import all migrations and provide a way to run all

require_relative '00001_create_messages_table.rb'
require_relative '00002_create_users_table.rb'

class Migrations
  MIGRATIONS = [
    CreateMessagesTable,
  ]

  def self.migrate(direction)
    migrations_in_order(direction).each do |m|
      m.migrate(direction)
    end
  end

  def self.migrations_in_order(direction)
    case direction
    when :up
      MIGRATIONS
    when :down
      MIGRATIONS.reverse
    end
  end
end
