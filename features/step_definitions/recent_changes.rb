Then /^I should see a list with changes$/ do
  page.should have_css('#page_content.history')
  page.should have_css('#page_content ol > li')
end
