require 'spec_helper'

describe "meutewiki/show.html.haml" do
  before(:each) do
    assign(:wiki_page, double("Gollum::Page", :name => 'TestPage', :formatted_data => "Test content"))
  end

  it "should render the content" do
    render
    rendered.should have_css("div#page_content", :text => "Test content")
  end

  it "should render a link edit page" do
    render
    pending "seems menu_item-method has to be implemented as using a stub for testing"
    rendered.should have_css("a", :href => meutewiki_edit_page_path('TestPage'))
  end

  it "should render a link to history page" do
    render
    pending "seems menu_item-method has to be implemented as using a stub for testing"
    rendered.should have_css("a", :href => meutewiki_page_history_path('TestPage'))
  end

  it "should render a link to the file upload page" do
    render
    pending "seems menu_item-method has to be implemented as using a stub for testing"
    rendered.should have_css("a", :href => new_file_asset_path)
  end
end
