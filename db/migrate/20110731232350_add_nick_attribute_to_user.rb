class AddNickAttributeToUser < ActiveRecord::Migration
  def change
    add_column :users, :nick, :string, :unique => true
    add_index :users, :nick
  end
end
