class CreateFileAssets < ActiveRecord::Migration
  def self.up
    create_table :file_assets do |t|
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.integer :file_width
      t.integer :file_height
      t.datetime :file_updated_at
    end
  end

  def self.down
  end
end
