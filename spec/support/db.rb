# frozen_string_literal: true

require_relative '../../migrations/migrations'

RSpec.configure do |c|
  c.before(:suite) do
    Migrations.up
    Message.destroy_all
  end

  c.around(:example, :db) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
