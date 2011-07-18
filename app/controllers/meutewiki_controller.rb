class MeutewikiController < ApplicationController
  before_filter :load_wiki

  def index
  end

  def front_page
    @wiki_page = find_front_page
    if @wiki_page.versions.empty? then
      redirect_to meutewiki_new_path
    else
      render 'show'
    end
  end

  def new
    @wiki_page = @wiki.page('')
    render 'new'
  end

  private

  def find_front_page
    @wiki.page('FrontPage')
  end

  def load_wiki
    @wiki = Gollum::Wiki.new(MEUTEWIKI_CONFIG['repo'], MEUTEWIKI_CONFIG['base_path'])
  end

end
