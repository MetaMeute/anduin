class CreateFacets < ActiveRecord::Migration
  def self.up
    create_table :facets do |t|
      t.string :caption
      t.string :color
      t.string :order
      t.integer :catalog_id
    end
  end

  def self.down
    drop_table :facets
  end
end
