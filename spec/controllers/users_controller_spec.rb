require 'spec_helper'

describe UsersController do

  describe "GET 'sign_up'" do
    it "should be successful" do
      get 'sign_up'
      response.should render_template('devise/registrations/new')
    end
  end

end
