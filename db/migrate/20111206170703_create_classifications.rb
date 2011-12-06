class CreateClassifications < ActiveRecord::Migration
  def self.up
    create_table :classifications do |t|
      t.integer :catalog_id
      t.integer :asset_id
    end
  end

  def self.down
    drop_table :classifications
  end
end
