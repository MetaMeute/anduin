require 'spec_helper'

describe MeutewikiController do

  context "with empty wiki" do
    describe "GET 'front_page'" do
      before(:each) do
        controller.stub!(:find_front_page){ double("Gollum::Page", :versions => []) }
      end

      it "should redirect to the new wiki page page" do
        get 'front_page'
        response.should redirect_to meutewiki_new_path
      end
    end
  end

  describe "GET 'new'" do
    it "should render the new template" do
      get 'new'
      response.should be_success
      response.should render_template('meutewiki/new')
    end
  end

  context "with example wiki" do
    describe "GET 'index'" do
      it "should render the index template" do
        get 'index'
        response.should render_template('meutewiki/index')
      end
    end
    describe "GET 'front_page'" do
      it "should render the front page" do
        get 'front_page'
        response.should render_template('meutewiki/show')
      end
    end
  end

end
