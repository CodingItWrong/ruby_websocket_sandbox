require_relative '../lib/db'

class CreateUsersTable < ActiveRecord::Migration[6.1]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:users)
      create_table :users do |t|
        t.string :email, null: false
        t.string :password_digest, null: false
        t.timestamps
      end

      add_index :users, :email, unique: true
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:users)
      drop_table :users
    end
  end
end
