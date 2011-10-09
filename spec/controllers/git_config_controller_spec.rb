require 'spec_helper'

describe GitConfigController do

  before(:each) do
    request.env['HTTP_ACCEPT_LANGUAGE'] = "de, en"
  end

  describe "GET 'edit'" do
    let(:params) do
      c = GitConfig.create!(:name => "Test Name", :email => "test@example.com")
      {:id => c.id}
    end

    it "should be successful" do
      get 'edit', params
      response.should be_success
      assigns(:git_config).name.should == "Test Name"
      assigns(:git_config).email.should == "test@example.com"
    end
  end

  describe "POST 'create'" do
    let(:params) do
      {:git_config => {:name => "Testname", :email => "test@example.com"}}
    end

    it "should be successful" do
      post 'create', params
      response.should redirect_to(edit_git_config_path(1))
      GitConfig.find(1).name.should == "Testname"
    end
  end

  describe "PUT 'update'" do
    let(:params) do
      c = GitConfig.create!
      {:id => c.id, :git_config => {:name => "Testname", :email => "test@example.com"}}
    end

    it "should be successful" do
      put 'update', params
      response.should redirect_to(edit_git_config_path(params[:id]))
      GitConfig.find(params[:id]).name.should == "Testname"
    end
  end

end
