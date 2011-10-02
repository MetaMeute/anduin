require 'spec_helper'

describe GitConfig do
  it "should have a name attribute" do
    c = GitConfig.new
    c.name = "test name"
    c.name.should == "test name"
  end
  it "should have an email attribute" do
    c = GitConfig.new
    c.email = "test@example.com"
    c.email.should == "test@example.com"
  end
end
