require 'spec_helper'

describe UsersController do
  before(:each) do
    request.env['HTTP_ACCEPT_LANGUAGE'] = "de, en"
  end

  describe "GET 'sign_up'" do
    it "should be successful" do
      get 'sign_up'
      response.should render_template('users/sign_up', 'layout/application')
    end
  end

end
