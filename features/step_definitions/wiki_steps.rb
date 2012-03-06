Then /^I should be on a wiki page named "([^"]*)"$/ do |page_name|
  current_path.should == meutewiki_show_page_path(page_name)
end

Then /^the file "([^"]*)" is part of the wiki$/ do |file_name|
  file = FileAsset.find_by_file_file_name(:file_name)
  file.should_not be_nil
  file.asset.classifications.find( Catalog.find_by_name(:wiki_files) ).should be_true
end

