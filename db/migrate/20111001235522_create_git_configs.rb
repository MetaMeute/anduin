class CreateGitConfigs < ActiveRecord::Migration
  def change
    create_table :git_configs do |t|
      t.string :name
      t.string :email
      t.integer :user_id

      t.timestamps
    end

    User.all.each do |u|
      u.git_config = GitConfig.new
    end
  end
end
