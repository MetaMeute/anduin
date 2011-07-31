require 'spec_helper'

describe User do
  describe "minimal information" do
    it "should be valid with email and password" do
      u = User.new(:email => 'test@example.com')
      u.password='testpassword'
      u.should be_valid
    end

    describe "should not be valid" do
      it { User.new(:email => 'test@example.com').should_not be_valid }
      it { User.new(:email => 'wrongmail', :password => 'testpassword').should_not be_valid }
    end
  end

  describe "optional information" do
    let(:user) { User.find_by_email('test@example.com') }
    before(:each) { User.create!(:email => 'test@example.com', :password => 'testpassword') }
  end
end
