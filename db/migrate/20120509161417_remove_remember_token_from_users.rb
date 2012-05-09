class RemoveRememberTokenFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :rember_token
  end

  # down method not needed. this column isn’t supported in devise any longer
end
