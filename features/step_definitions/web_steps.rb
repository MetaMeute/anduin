Given /^I am on the wiki front page$/ do
  visit '/meutewiki'
end

Given /^I am on the home page$/ do
  visit '/'
end

Then /^I should be on the login page$/ do
  current_path.should == new_user_session_path
end

Then /^I should see the "([^"]*)" image$/ do |alt_text|
  page.should have_css('img', :alt => alt_text)
end

When /^I follow "([^"]*)"$/ do |link_name|
  click_link link_name
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should not see "([^"]*)"$/ do |text|
  page.should_not have_content(text)
end

When /^I go the home page$/ do
  visit '/'
end

Then /^I should be on the account page$/ do
  current_path.should =~ /^\/users\/[0-9]+\/edit$/
end
