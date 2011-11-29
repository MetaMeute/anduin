Given /^I am on the wiki front page$/ do
  visit '/meutewiki'
end

Then /^I should see the "([^"]*)" image$/ do |alt_text|
  page.should have_css('img', :alt => alt_text)
end
