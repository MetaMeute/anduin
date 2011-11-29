require 'spec_helper'

describe UsersController do
  describe "language detection in HTTP header" do
    it "should not fail without language set in header" do
      get :sign_up
      response.should be_success
    end
  end
end
