require 'spec_helper'

describe "users/edit.html.haml" do
  describe "users/_password_fields.html.haml" do
    it "should have a field for the e-mail address" do
      u = mock_model(User, :email => "")
      assign :user, u
      render
      rendered.should have_css("form > label", :text => "Email")
      rendered.should have_css("form > input#user_email")
    end
  end
end

