class AddClipboard < ActiveRecord::Migration
  def self.up
    add_column :tray_positions, :clipboard_type, :string
    add_column :tray_positions, :clipboard_id, :integer
  end

  def self.down
    remove_column :tray_positions, :clipboard_type, :string
    remove_column :tray_positions, :clipboard_id, :integer
  end
end
