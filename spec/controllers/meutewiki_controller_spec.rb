require 'spec_helper'

describe MeutewikiController do

  context "with empty wiki" do
    describe "GET 'front_page'" do
      before(:each) do
        controller.stub!(:find_front_page){ nil }
      end

      it "should redirect to the new wiki page page" do
        get 'front_page'
        response.should redirect_to meutewiki_show_page_path('FrontPage')
      end
    end
  end

  context "with example wiki" do
    describe "GET 'index'" do
      it "should render the index template" do
        get 'index'
        response.should render_template('meutewiki/index')
      end

      it "should assign all pages in the wiki" do
        get 'index'
        assigns(:wiki_pages).should have(2).items
      end
    end

    describe "GET 'front_page'" do
      it "should render the front page" do
        get 'front_page'
        response.should redirect_to meutewiki_show_page_path('FrontPage')
      end
    end

    describe "GET 'show'" do
      it "should render the page" do
        get 'show', :name => 'TestPage'
        assigns(:wiki_page).should_not be_nil
      end

      it "should render the new template" do
        get 'show', :name => 'TestPage'
        response.should be_success
        response.should render_template('meutewiki/show')
      end
    end
  end

end
