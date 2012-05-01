require 'spec_helper'

describe GitConfigsController do

  before(:each) do
    request.env['HTTP_ACCEPT_LANGUAGE'] = "de, en"
  end

  describe "GET 'edit'" do
    let(:params) do
      u = User.create!(:nick => 'Robert')
      u.git_config.update_attributes!(:name => "Test Name", :email => "test@example.com")
      u.save!
      @controller.stub!(:current_user) { u }
      {:id => u.git_config.id}
    end

    it "should be successful" do
      get 'edit', params
      response.should be_success
      assigns(:git_config).name.should == "Test Name"
      assigns(:git_config).email.should == "test@example.com"
    end
  end

  describe "PUT 'update'" do
    let(:params) do
      u = User.create!(:nick => 'Robert')
      @controller.stub!(:current_user) { u }
      {:id => u.git_config.id, :git_config => {:name => "Testname", :email => "test@example.com"}}
    end

    it "should be successful" do
      put 'update', params
      response.should render_template('edit')
      GitConfig.find(params[:id]).name.should == "Testname"
    end
  end

end
