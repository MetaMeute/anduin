class CreateCatalogs < ActiveRecord::Migration
  def self.up
    create_table :catalogs do |t|
      t.string :title
      t.string :permalink
      t.text :info
    end
  end

  def self.down
    drop_table :catalogs
  end
end
