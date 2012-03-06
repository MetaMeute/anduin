Given /^a catalog named "([^"]*)"$/ do |name|
  Catalog.create!(:title => name)
end

