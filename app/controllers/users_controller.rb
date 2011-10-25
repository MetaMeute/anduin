class UsersController < ApplicationController
  def sign_up
    @user = User.new
  end

  def register
    flash[:notice] = 'User created, now please sign in.'
    redirect_to new_user_session_path
  end

end
