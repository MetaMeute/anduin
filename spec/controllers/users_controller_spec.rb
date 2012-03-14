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

  describe "POST 'register'" do
    describe "information stored in LDAP" do
      let(:obj_classes) do
        ["top", "inetOrgPerson", "sambaSamAccount"]
      end
      let(:nick) { "Robert" }

      let(:ldap_config) { YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env] }
      let(:base_dn) { ldap_config["base"] }
      let(:ldap) do
        ldap = Net::LDAP.new
        ldap.host = ldap_config["host"]
        ldap.auth ldap_config["admin_user"], ldap_config["admin_password"]
        if !ldap.bind then
          throw "Could not bind to ldap"
        end
        ldap
      end

      before(:each) do
        post 'register', { :user => {:nick => nick, :password => 'test1234', :password_confirmation => 'test1234'} }
        response.should redirect_to new_user_session_path
      end

      after(:each) do
        ldap.delete(:dn => "cn=#{nick},#{base_dn}")
      end

      it "should have correct object classes" do
        f = Net::LDAP::Filter.eq("cn", nick)
        ldap.search( :base => base_dn, :filter => f, :attributes => ['objectclass'] ) do |entry|
          obj_classes.each do |obj_class|
            entry["objectclass"].should include(obj_class)
          end
        end
      end

      describe "nick attributes" do
        it "should store the nick in cn attribute" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['cn'] ) do |entry|
            entry["cn"].should include(nick)
          end
        end
        it "should store the nick in sambaSID attribute" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['sambaSID'] ) do |entry|
            entry["sambaSID"].should include(nick)
          end
        end
        it "should store the nick in sn attribute" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['sn'] ) do |entry|
            entry["sn"].should include(nick)
          end
        end
        it "should store the nick in uid attribute" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['uid'] ) do |entry|
            entry["uid"].should include(nick)
          end
        end
      end

      describe "password attributes" do
        it "should store userPassword" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['userPassword'] ) do |entry|
            entry["userPassword"].should_not be_empty
          end
        end

        it "should store sambaLMPassword" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['sambaLMPassword'] ) do |entry|
            entry["sambaLMPassword"].should_not be_empty
            entry["sambaLMPassword"].first.should == "624AAC413795CDC1FF17365FAF1FFE89"
          end
        end

        it "should store sambaNTPassword" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['sambaNTPassword'] ) do |entry|
            entry["sambaNTPassword"].should_not be_empty
            entry["sambaNTPassword"].first.should == "3B1B47E42E0463276E3DED6CEF349F93"
          end
        end
      end
    end
  end
end
