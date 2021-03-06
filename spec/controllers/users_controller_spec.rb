# encoding: UTF-8
require 'spec_helper'

describe UsersController do
  before(:each) do
    request.env['HTTP_ACCEPT_LANGUAGE'] = "de, en"
  end

  describe "GET 'edit'" do
    fixtures :users, :git_configs
    before(:each) do
      @controller.stub!(:current_user) { User.find 1 }
    end

    it "should assign a user" do
      user = User.find 1
      get 'edit', { :id => user.id }
      assigns(:user).should == user
    end
  end

  describe "GET 'sign_up'" do
    it "should be successful" do
      get 'sign_up'
      response.should render_template('users/sign_up', 'layout/application')
    end
  end

  describe "PUT 'update'" do
    it "should assign a user" do
      user = User.find 1
      @controller.stub!(:current_user) { user }
      put 'update', { :id => user.id }
      assigns(:user).should == user
    end

    it "should update the git config of the user" do
      user = User.find 1
      @controller.stub!(:current_user) { user }
      put 'update', { :id => user.id, :user => { :git_config_attributes => { :name => "Test User" } } }
      gc = assigns(:user).git_config
      gc.name.should == "Test User"
      gc.should_not be_changed
    end

    it "should update the email attribute of user" do
      user = User.find 1
      test_email = 'test@example.com'
      user.email.should_not == test_email
      @controller.stub!(:current_user) { user }
      put 'update', { :id => user.id, :user => { :email => test_email } }
      User.find(1).email.should == test_email
    end

    it "should not update the attributes of another user" do
      user = User.find 1
      test_email = 'test@example.com'
      user.email.should_not == test_email
      @controller.stub!(:current_user) { nil }
      put 'update', { :id => user.id, :user => { :email => test_email } }
      response.should be_forbidden
      User.find(1).email.should_not == test_email
    end
  end

  describe "authentication" do
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
        @controller.stub!(:current_user) { User.find_by_nick :nick }
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

      describe "very secure passwords" do
        it "should not fail when entering passwords with unicode characters" do
          p = "8?(hts[e`D2ZPHüß"
          u = User.find_by_nick(nick)
          u.send_reset_password_instructions
          put 'reset_password', { "user" => {
                                    "reset_password_token" => u.reset_password_token,
                                    "password" => p,
                                    "password_confirmation" => p
                                  }
                                }
          response.should redirect_to edit_user_path(u)
        end
      end

      describe "reset password" do
        before(:each) do
          u = User.find_by_nick(nick)
          u.send_reset_password_instructions
          put 'reset_password', { "user" => {
                                    "reset_password_token" => u.reset_password_token,
                                    "password" => "test4321",
                                    "password_confirmation" => "test4321"
                                  }
                                }
        end

        it "should provide an useful error if no password token is present" do
          put 'reset_password', { "user" => {
                                    "reset_password_token" => "none!",
                                    "password" => "t",
                                    "password_confirmation" => "t"
                                  }
                                }
          response.should redirect_to(new_user_password_path)
          flash[:error].should == "Unable to reset password, please follow the instructions in the mail."
        end

        it "should reset userPassword" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['userPassword'] ) do |entry|
            entry["userPassword"].should_not be_empty
            # TODO: may be, we should check it actually changed; how?
          end
        end

        it "should reset sambaLMPassword" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['sambaLMPassword'] ) do |entry|
            entry["sambaLMPassword"].should_not be_empty
            entry["sambaLMPassword"].first.should == "C959BEC57C2EF53BC2265B23734EDAC"
          end
        end

        it "should reset sambaNTPassword" do
          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f, :attributes => ['sambaNTPassword'] ) do |entry|
            entry["sambaNTPassword"].should_not be_empty
            entry["sambaNTPassword"].first.should == "9F699D92689E51641866F45D71553987"
          end
        end
      end

      describe "with missing ldap attributes" do
        let(:expected) do
          {
            "objectclass" => ["top", "inetOrgPerson", "sambaSamAccount"],
            :cn => [nick],
            :sn => [nick],
            :uid => [nick],
            :sambaSID => [nick],
            "sambaLMPassword" => ["C959BEC57C2EF53BC2265B23734EDAC"],
            "sambaNTPassword" => ["9F699D92689E51641866F45D71553987"]
          }
        end

        after(:each) do
          u = User.find_by_nick(nick)
          u.send_reset_password_instructions
          put 'reset_password', { "user" => {
                                    "reset_password_token" => u.reset_password_token,
                                    "password" => "test4321",
                                    "password_confirmation" => "test4321"
                                  }
                                }

          f = Net::LDAP::Filter.eq("cn", nick)
          ldap.search( :base => base_dn, :filter => f ) do |entry|
            expected.each { |key, value| entry[key].should == value }
            entry["userPassword"].should_not be_empty
          end
        end

        it "should create sambaSamAccounts" do
          dn = "cn=#{nick},#{base_dn}"
          attr = {
            "objectclass" => ["top", "inetOrgPerson"],
            "cn" => nick,
            "sn" => nick,
            "userPassword" => ""
          }
          ldap.delete(:dn => dn)
          ldap.add(:dn => dn, :attributes => attr)
          if ldap.get_operation_result.code != 0 then
            throw "LDAP error: #{ldap.get_operation_result.message}"
          end
        end
      end
    end
  end
end

