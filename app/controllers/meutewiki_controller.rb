class MeutewikiController < ApplicationController
  respond_to :html, :js

  before_filter :load_wiki

  def index
    @wiki_pages = @wiki.pages.nil? ? [] : @wiki.pages
  end

  def show
    @wiki_page = @wiki.page(params[:name])
    if @wiki_page.nil? then
      redirect_to meutewiki_edit_page_path(params[:name])
    end
  end

  def front_page
    redirect_to meutewiki_show_page_path(:name => 'FrontPage')
  end

  def edit
    @wiki_page = @wiki.page(params[:name]) || @wiki.preview_page(params[:name], "", :markdown)
  end

  def update
    commit = {}
    commit.merge({:message => params[:message]}) if params[:message]
    @wiki_page = @wiki.page(params[:name])
    if params[:commit] =~ /^Save/ && @wiki_page then
      @wiki.update_page(@wiki_page, params[:name], :markdown, params[:wiki_page][:raw_data], commit)
      flash[:notice] = t "Page updated."
    elsif params[:commit] =~ /^Save/ && @wiki_page.nil? then
      @wiki_page = @wiki.write_page(params[:name], :markdown, params[:wiki_page][:raw_data], commit)
      flash[:notice] = t "Page created."
    elsif params[:commit] =~ /^Preview$/ then
      @wiki_page = @wiki.preview_page(params[:name], params[:wiki_page][:raw_data], :markdown)
    elsif params[:commit] =~ /^Cancel$/ then
      flash[:notice] = t "Update cancelled."
    end

    url = button_path_for(params[:commit])
    @button = params[:commit]
    respond_with(@wiki_page, @button, :location => url) do |format|
      format.html { render 'edit', {:wiki_page => @wiki_page, :button => @button} } if @button == 'Preview'
    end
  end

  private

  def button_path_for(button)
    case button
      when /^Save$/
        url = meutewiki_show_page_path(params[:name])
      when /^Save and continue$/
        url = meutewiki_edit_page_path(params[:name])
      when /^Cancel/
        url = meutewiki_show_page_path(params[:name])
    end
  end

  def load_wiki
    @wiki = Gollum::Wiki.new(MEUTEWIKI_CONFIG['repo'], :base_path => MEUTEWIKI_CONFIG['base_path'])
  end

end
