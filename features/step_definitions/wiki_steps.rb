Then /^I should be on a wiki page named "([^"]*)"$/ do |page_name|
  current_path.should == meutewiki_show_page_path(page_name)
end

