Given /^I am not logged in$/ do
  # do nothing here
end

Given /^I am logged in as "([^"]*)"$/ do |nick|
  User.create!(:nick => nick)
  visit new_user_session_path
  within("#user_new") do
    fill_in :nick, :with => nick
    fill_in :password, :with => "secure!" # fake_auth.rb allows to use any nick with this pw to authenticate
  end
  click_button :sign_in
end

