class CreateTrayPositions < ActiveRecord::Migration
  def self.up
    create_table :tray_positions do |t|
      t.integer :user_id
      t.integer :position
      t.integer :asset_id
    end
  end

  def self.down
    drop_table :tray_positions
  end
end
