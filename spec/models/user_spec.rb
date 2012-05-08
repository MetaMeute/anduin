require 'spec_helper'

describe User do
  describe "minimal information" do
    it "should be valid with email" do
      u = User.new(:email => 'test@example.com')
      u.should be_valid
    end
  end

  describe "optional information" do
    let(:user) { User.find_by_email('test@example.com') }
    before(:each) do
      u = User.create!
      u.email = 'test@example.com'
      u.save!
    end

    after(:each) { user.should be_valid }
    it "might have a nickname" do
      user.nick = 'gandalf'
      user.nick.should eq('gandalf')
    end
  end

  describe "git config" do
    let(:user) { User.find_by_nick('test') }
    before(:each) do
      u = User.create!(:nick => 'test')
    end

    it "should create a git config on creation" do
      user.git_config.should_not be_nil
    end

    it "should update the git config" do
      user.update_attributes({ :git_config_attributes => { :name => "testname" } })
      user.git_config.name.should == "testname"
    end

  end
end
