Given /^a catalog named "([^"]*)"$/ do |name|
  FassetsCore::Catalog.create!(:title => name)
end

