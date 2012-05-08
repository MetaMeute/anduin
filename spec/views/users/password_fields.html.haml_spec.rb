require 'spec_helper'

describe "users/edit.html.haml" do
  describe "users/_password_fields.html.haml" do
    before(:each) do
      gc = mock_model(GitConfig, :name => "", :email => "")
      u = mock_model(User, :email => "", :git_config => gc)
      assign :user, u
    end

    it "should have a field for the e-mail address" do
      render
      rendered.should have_css("form label", :text => "Email")
      rendered.should have_css("form input#user_email")
    end

    it "should have fields to change the password" do
      render
      rendered.should have_css("form label", :text => "New password")
      rendered.should have_css("form input#user_password")
      rendered.should have_css("form label", :text => "Confirm new password")
      rendered.should have_css("form input#user_password_confirmation")
    end
  end
end

