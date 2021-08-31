require_relative '../lib/db'

class CreateMessagesTable < ActiveRecord::Migration[6.1]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:messages)
      create_table :messages do |t|
        t.string :contents, null: false
        t.timestamps
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:messages)
      drop_table :messages
    end
  end
end
