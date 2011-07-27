require 'spec_helper'

describe "meutewiki/edit.html.haml" do
  describe "with existing wiki page" do
    before(:each) do
      assign(:wiki_page, double("Gollum::Page", :name => "Testpage", :raw_data => "# some header #"))
      render
    end

    it "should render a form" do
      rendered.should have_css("form[method=post]")
    end

    it "should render a textarea" do
      rendered.should have_css("textarea", :content => "# some header #")
    end

    it "should provide the name of the wiki page" do
      rendered.should have_css("input[type=hidden]", :value => "TestPage")
    end

    it "should render submit buttons" do
      rendered.should have_css("input[type=submit]", "Save")
      rendered.should have_css("input[type=submit]", "Save and continue")
      rendered.should have_css("button", "Preview")
      rendered.should have_css("input[type=submit]", "Cancel")
    end
  end
end
