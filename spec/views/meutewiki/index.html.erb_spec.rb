require 'spec_helper'

describe "meutewiki/index.html.erb" do
  it "should render a list of pages" do
    assign(:wiki_pages,
           [double("Gollum::Page", :name => 'TestPage1'),
            double("Gollum::Page", :name => 'TestPage2')]
          )
    render
    rendered.should have_css("a", :href => meutewiki_show_page_path('TestPage1'))
    rendered.should have_css("a", :href => meutewiki_show_page_path('TestPage2'))
  end
end
