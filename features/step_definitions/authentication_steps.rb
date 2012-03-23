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
  ldap = init_ldap
  ldap.delete(:dn => "cn=#{nick},#{base_dn}")
end

