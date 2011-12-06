class CreateLabelings < ActiveRecord::Migration
  def self.up
    create_table :labelings do |t|
      t.integer :classification_id
      t.integer :label_id
    end
  end

  def self.down
    drop_table :labelings
  end
end
