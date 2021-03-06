class MeutewikiController < ApplicationController
  respond_to :html, :js

  before_filter :load_wiki
  before_filter :fetch_commit_info, :only => [:update]

  def index
    @wiki_pages = @wiki.pages.nil? ? [] : @wiki.pages
  end

  def show
    if isAssetFormat(params[:format]) then
      name = "#{params[:name]}.#{params[:format]}"
      file = @wiki.file(name)
      respond_to do |format|
        format.png { send_data(file.raw_data, :filename => name, :type => "image/png") }
        format.pdf { send_data(file.raw_data, :filename => name, :type => "image/pdf") }
        format.jpg { send_data(file.raw_data, :filename => name, :type => "image/jpeg") }
      end
    else
      @wiki_page = @wiki.page(params[:name])
      if @wiki_page.nil? then
        redirect_to meutewiki_edit_page_path(params[:name])
      end
    end
  end

  def front_page
    redirect_to meutewiki_show_page_path(:name => 'FrontPage')
  end

  def edit
    @wiki_page = @wiki.page(params[:name]) || @wiki.preview_page(params[:name], "", :markdown)
  end

  def update
    @wiki_page = @wiki.page(params[:name])
    if params[:commit].include?(t("Save")) && @wiki_page then
      @wiki.update_page(@wiki_page,
                        params[:name],
                        :markdown,
                        params[:wiki_page][:raw_data],
                        @commit_info
                       )
      flash[:notice] = t "Page updated."
    elsif params[:commit].include?(t("Save")) && @wiki_page.nil? then
      @wiki_page = @wiki.write_page(params[:name],
                                    :markdown,
                                    params[:wiki_page][:raw_data],
                                    @commit_info
                                   )
      flash[:notice] = t "Page created."
    elsif params[:commit] == t("Preview") then
      @wiki_page = @wiki.preview_page(params[:name],
                                      params[:wiki_page][:raw_data],
                                      :markdown
                                     )
    elsif params[:commit] == t("Cancel") then
      flash[:notice] = t "Update cancelled."
    end

    url = button_path_for(params[:commit])
    @button = params[:commit]
    respond_with(@wiki_page, @button, @commit_info, :location => url) do |format|
      format.html { render 'edit', {:wiki_page => @wiki_page, :button => @button, :commit_info => @commit_info} } if @button == 'Preview'
    end
  end

  def history
    @wiki_page = @wiki.page(params[:name])
    @history = []
    @history = @wiki_page.versions unless @wiki_page.nil?
  end

  private

  def button_path_for(button)
    case button
      when t("Save")
        url = meutewiki_show_page_path(params[:name])
      when t("Save and continue")
        url = meutewiki_edit_page_path(params[:name])
      when t("Cancel")
        url = meutewiki_show_page_path(params[:name])
    end
  end

  def load_wiki
    @wiki = Gollum::Wiki.new(MEUTEWIKI_CONFIG['repo'], :base_path => MEUTEWIKI_CONFIG['base_path'])
  end

  def fetch_commit_info
    name = current_user.git_config.name
    email = current_user.git_config.email
    @commit_info = {}
    @commit_info.merge!({:message => params[:message]}) unless params[:message].nil?
    @commit_info.merge!({:name => name}) unless name.nil?
    @commit_info.merge!({:email => email}) unless email.nil?
  end

  def isAssetFormat(f)
    case f
    when "png"
      true
    when "jpg"
      true
    when "pdf"
      true
    else
      false
    end
  end

end
