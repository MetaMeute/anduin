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

Then /^I should see a form with fields:$/ do |table|
  table.rows.each do |row|
    page.should have_css("form", :text => row.first)
  end
end

When /^I fill in "([^"]*)" into "([^"]*)"$/ do |value, field|
  fill_in field_to_id(field), :with => value
end

When /^I select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select value, :from => field_to_id(field)
end

When /^I upload the testfile "([^"]*)"$/ do |file_name|
  attach_file 'file_asset_file', "#{File.join([Rails.root,"spec","fixtures",file_name])}"
end

When /^I submit the form$/ do
  click_on :commit
end

