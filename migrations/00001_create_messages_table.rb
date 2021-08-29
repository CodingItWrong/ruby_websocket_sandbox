require_relative '../lib/db'

class CreateMessagesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.string :contents
      t.timestamps
    end
  end
end

CreateMessagesTable.migrate(:up)
