require 'spec_helper'

describe "meutewiki/history.html.haml" do
  it "should render a list of pages" do
    assign(:history,
           [double("Grit::Commit",
                   :id_abbrev => '1234abc',
                   :author => "Test Author",
                   :message => "a message"),
            double("Grit::Commit",
                   :id_abbrev => '1235abc',
                   :author => "Test Author",
                   :message => "another message")
           ]
          )
    assign(:wiki_page, double("Gollum::Page", :name => "TestPage"))
    render
    rendered.should have_css("ol")
    rendered.should have_css("li", :text => "Test Author")
    rendered.should have_css("li", :text => "another message")
  end
end