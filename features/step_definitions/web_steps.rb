Given /^I am on the wiki front page$/ do
  visit '/meutewiki'
end

Then /^I should see the "([^"]*)" image$/ do |alt_text|
  page.should have_css('img', :alt => alt_text)
end

When /^I follow "([^"]*)"$/ do |link_name|
  click_link link_name
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_text(text)
end
