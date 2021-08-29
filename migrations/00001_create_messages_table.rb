require_relative '../lib/db'

class CreateMessagesTable < ActiveRecord::Migration[6.1]
  def up
    create_table :messages do |t|
      t.string :contents
      t.timestamps
    end
  end

  def down
    drop_table :messages
  end
end

CreateMessagesTable.migrate(:up)
