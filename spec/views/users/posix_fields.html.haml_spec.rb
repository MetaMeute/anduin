require 'spec_helper'

describe "users/edit.html.haml" do
  describe "users/_posix_fields.html.haml" do
    before(:each) do
      gc = mock_model(GitConfig, :name => "", :email => "")
      u = mock_model(User, :email => "", :git_config => gc)
      assign :user, u
    end

    it "should provide a section for posix settings" do
      render
      rendered.should have_css("h1.section", :text => "Posix Settings")
    end

    it "should have a field for the shell" do
      render
      rendered.should have_css("form label", :text => "Login shell")
      rendered.should have_css("form select#user_posix_settings_login_shell")
    end
 end
end

