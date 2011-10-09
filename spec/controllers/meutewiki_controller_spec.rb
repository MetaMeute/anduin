require 'spec_helper'

describe MeutewikiController do

  before(:each) do
    request.env['HTTP_ACCEPT_LANGUAGE'] = "de, en"
  end

  it "should assign a wiki with correct base path" do
    get 'front_page'
    assigns(:wiki).base_path.should eq("/meutewiki")
  end

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
      it "should render an existing page" do
        get 'show', :name => 'TestPage'
        response.should be_success
        response.should render_template('meutewiki/show')
        assigns(:wiki_page).should_not be_nil
      end

      it "should redirect to the edit action for non-existing pages" do
        get 'show', :name => 'SomeThingNew'
        response.should redirect_to meutewiki_edit_page_path('SomeThingNew')
      end
    end
  end

  describe "GET 'edit'" do
    it "should render the edit partial" do
      get 'edit', {:name => 'SomeThingNew'}
      response.should be_success
      response.should render_template('meutewiki/edit')
    end

    describe "with non-existing page" do
      before(:each) { get 'edit', {:name => 'SomeThingNew'} }
      it { assigns(:wiki_page).should_not be_nil }
      it { assigns(:wiki_page).name.should eq('SomeThingNew') }
      it { assigns(:wiki_page).format.should eq(:markdown) }
    end

    describe "with existing page" do
      it "should assign the existing wiki page" do
        get 'edit', {:name => 'TestPage'}
        assigns(:wiki_page).should_not be_nil
      end
    end
  end

  describe "PUT 'update'" do
    let(:content) do
      "# Title #

      This is some test *page* data
      "
    end
    let(:data) do
      {:wiki_page => { :raw_data => content},
       :name => 'SomeThingNew'}
    end
    before(:each) { controller.stub!(:current_user){ double(User, :git_config => GitConfig.new)} }

    describe "HTML request" do
      describe "saving the page" do
        after(:each) do
          assigns(:wiki).page('SomeThingNew').should_not be_nil
          assigns(:wiki).repo.update_ref("master","37a3f16436c639bada9fdb53b0c2a76af59928d7")
        end
        it "should show the page when save is clicked" do
          put 'update', data.merge({:commit => 'Save'})
          response.should redirect_to(meutewiki_show_page_path('SomeThingNew'))
          request.flash[:notice].should =~ /created/
        end
        it "should show the edit page when save and continue is clicked" do
          put 'update', data.merge({:commit => 'Save and continue'})
          response.should redirect_to(meutewiki_edit_page_path('SomeThingNew'))
        end
      end
      describe "not saving the page" do
        it "should redirect to edit with preview parameter set" do
          put 'update', data.merge({:commit => 'Preview'})
          response.should render_template('meutewiki/edit')
          assigns(:wiki_page).should_not be_nil
          assigns(:button).should eq('Preview')
        end

        it "should redirect to the show action, when user canceled" do
          put 'update', data.merge({:commit => 'Cancel'})
          response.should redirect_to(meutewiki_show_page_path('SomeThingNew'))
        end
      end
    end

    describe "commit info" do
      let(:git_config) do
        double(GitConfig, :name => "Test User", :email => "test@example.com")
      end

      it "should assign the message" do
        put 'update', data.merge({:message => "Test message", :commit => 'Preview'})
        assigns(:commit_info)[:message].should == "Test message"
      end

      it "should assign the authors git config" do
        controller.stub!(:current_user) { double(User, :git_config => git_config) }
        put 'update', data.merge({:message => "Test message", :commit => 'Preview'})
        assigns(:commit_info)[:author].should == git_config.name
        assigns(:commit_info)[:email].should == git_config.email
      end

      it "should not assign nothing for unset config variables" do
        controller.stub!(:current_user) { double(User, :git_config => double(GitConfig, :name => nil, :email => nil)) }
        put 'update', data.merge({:message => "Test message", :commit => 'Preview'})
        assigns(:commit_info)[:author].should be_nil
          assigns(:commit_info)[:email].should be_nil
      end
    end

    describe "AJAX request" do
      it { pending "someone needs to implement tests!" }
    end
  end

  describe "GET 'history'" do
    it "should render the history template" do
      get 'history', :name => 'TestPage'
      response.should be_success
      response.should render_template('meutewiki/history')
    end

    it "should assign the history for existing pages" do
      get 'history', :name => 'TestPage'
      assigns(:history).should have(1).item
    end

    it "should assign an empty history for non-existing pages" do
      get 'history', :name => "SomeStrangeNonExistingName"
      assigns(:history).should be_empty
    end

    it "should assign thi wiki page" do
      get 'history', :name => 'TestPage'
      assigns(:wiki_page).should_not be_nil
    end
  end
end
