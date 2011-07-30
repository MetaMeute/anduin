require 'spec_helper'

describe "meutewiki/edit.html.haml" do
  describe "with existing wiki page" do
    before(:each) do
      assign(:wiki_page, double("Gollum::Page",
                                :name => "Testpage",
                                :raw_data => "# some header #",
                                :formatted_data => "<h1>some header</h1>")
            )
      render
    end

    it "should render a form" do
      rendered.should have_css("form[method=post]")
    end

    it "should render a textarea" do
      rendered.should have_css("textarea", :text => /# some header #/)
    end

    it "should provide the name of the wiki page" do
      rendered.should have_css("input[type=hidden]", :value => "TestPage")
    end

    describe "preview area" do
      it { rendered.should have_css("div#page_content.preview") }
      it "should render the preview when requested" do
        assign(:button, 'Preview')
        render
        rendered.should have_css("div#page_content.preview h6", :text => 'Preview')
        rendered.should have_css("div#page_content.preview hr")
        rendered.should have_css("div#page_content.preview h1", :text => "some header")
      end
    end

    it "should render submit buttons" do
      rendered.should have_css("input[type=submit]", "Save")
      rendered.should have_css("input[type=submit]", "Save and continue")
      rendered.should have_css("input[type=submit]", "Preview")
      rendered.should have_css("input[id=preview_button]", "Preview")
      rendered.should have_css("input[type=submit]", "Cancel")
    end
  end
end
