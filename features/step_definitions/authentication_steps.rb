Given /^I am not logged in$/ do
  # do nothing here
end

Given /^I am logged in as "([^"]*)"$/ do |nick|
  User.create!(:nick => nick)
  visit new_user_session_path
  within("#user_new") do
    fill_in "Nick", :with => nick
    fill_in "Password", :with => "secure!" # fake_auth.rb allows to use any nick with this pw to authenticate
  end
  click_button "Sign in"
end

Given /^there is no user named "([^"]*)"$/ do |nick|
  ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
  ldap = Net::LDAP.new
  ldap.host = ldap_config["host"]
  ldap.auth ldap_config["admin_user"], ldap_config["admin_password"]
  if !ldap.bind then
    throw "Could not bind to ldap"
  end
  base_dn = ldap_config["base"]
  ldap.delete(:dn => "cn=#{nick},#{base_dn}")
end

