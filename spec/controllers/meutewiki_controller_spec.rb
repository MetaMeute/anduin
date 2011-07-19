require 'spec_helper'

describe MeutewikiController do

  context "with empty wiki" do
    before(:each) do
      controller.stub!(:find_front_page){ nil }
      controller.stub!(:load_wiki) { }
      wiki = double("Gollum::Wiki", :pages => nil)
      controller.instance_eval { @wiki = wiki }
    end

    describe "GET 'front_page'" do
      it "should redirect to the new wiki page page" do
        get 'front_page'
        response.should redirect_to meutewiki_show_page_path('FrontPage')
      end
    end

    describe "GET 'index'" do
      it "should allways asign wiki pages array" do
        get 'index'
        response.should be_success
        assigns(:wiki_pages).should respond_to(:each)
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
