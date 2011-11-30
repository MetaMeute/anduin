Then /^I should see a list with changes$/ do
  page.should have_css('#page_content.history')
  page.should have_css('#page_content ol > li')
end

Then /^the list contains:$/ do |table|
  list_elements = page.all('div#page_content.history ol > li')
  table.hashes.each do |col|
    list_elements.drop(1).first.should have_content(col[:author])
  end
end

Then /^the list should not contain more than (\d+) entries$/ do |counted|
  page.all('div#page_content.history ol').count.should <= counted.to_i
end

