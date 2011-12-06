class AddLabelOrdering < ActiveRecord::Migration
  def self.up
    add_column :labels, :position, :integer
    add_column :labels, :value, :integer
    add_column :facets, :label_order, :string
  end

  def self.down
  end
end
