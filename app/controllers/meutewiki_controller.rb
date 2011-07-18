class MeutewikiController < ApplicationController
  before_filter :load_wiki

  def index
  end

  def show
    @wiki_page = @wiki.page(params['name'])
    if @wiki_page.nil? then
      redirect_to meutewiki_edit_page_path(:name => params['name'])
    else
      render 'show'
    end
  end

  def front_page
    redirect_to meutewiki_show_page_path(:name => 'FrontPage')
  end

  def edit
    @wiki_page = @wiki.page(params['name'])
  end

  private

  def load_wiki
    @wiki = Gollum::Wiki.new(MEUTEWIKI_CONFIG['repo'], MEUTEWIKI_CONFIG['base_path'])
  end

end
