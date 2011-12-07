Given /^I am not logged in$/ do
  # do nothing here
end

Given /^I am logged in as "([^"]*)"$/ do |nick|
  User.create!(:nick => nick)
  visit new_user_session_path
  within("#user_new") do
    fill_in "user_nick", :with => nick
    fill_in "user_password", :with => "secure!" # fake_auth.rb allows to use any nick with this pw to authenticate
  end
  click_button :sign_in
  page.should have_link("Logout")
end

