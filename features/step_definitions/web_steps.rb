Given /^I am on the wiki front page$/ do
  visit '/meutewiki'
end

Given /^I am on the home page$/ do
  visit '/'
end

Given /^I am on the login page$/ do
  visit '/users/sign_in'
end

Given /^I am on the sign up page$/ do
  visit '/users/sign_up'
end

Then /^I should be on the login page$/ do
  current_path.should == new_user_session_path
end

Given /^I am on the forgot password page$/ do
  visit new_user_password_path
end

Then /^I should see the "([^"]*)" image$/ do |alt_text|
  page.should have_css('img', :alt => alt_text)
end

When /^I follow "([^"]*)"$/ do |link_name|
  click_link link_name
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in field, :with => value
end

When /^I click "([^"]*)"$/ do |button|
  click_button button
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should not see "([^"]*)"$/ do |text|
  page.should_not have_content(text)
end

When /^I visit my account settings page$/ do
  @user = User.find_by_nick("Robert")
  visit edit_user_path(@user)
end

When /^I go the home page$/ do
  visit '/'
end

Then /^I should be on the account page$/ do
  current_path.should =~ /^\/users\/[0-9]+\/edit$/
end

Then /^I should be on the sign up page$/ do
  current_path.should == '/users/sign_up'
end

Then /^I should be on the sign in page$/ do
  current_path.should == '/users/sign_in'
end

Then /^I should be on the forgot password page$/ do
  current_path.should == new_user_password_path
end

