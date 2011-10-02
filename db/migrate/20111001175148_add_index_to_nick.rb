class AddIndexToNick < ActiveRecord::Migration
  def change
    add_index :users, :nick
    remove_index :users, :email
  end
end
