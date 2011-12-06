class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :name
      t.boolean :public
      t.integer :content_id
      t.string :content_type
      t.integer :user_id
      t.integer :classifications_count
      t.timestamps
    end
  end

  def self.down
  end
end
