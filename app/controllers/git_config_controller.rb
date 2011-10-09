class GitConfigController < ApplicationController
  respond_to :html

  before_filter :find_git_config, :only => [:edit, :show, :update]

  def edit
  end

  def show
    render 'edit', { :git_config => @git_config }
  end

  def create
    c = GitConfig.create!(params[:git_config])
    redirect_to(edit_git_config_path(c))
  end

  def update
    @git_config.update_attributes(params[:git_config])
    @git_config.save!
    flash[:notice] = t "Git configuration updated."
    respond_with(@git_config) do |format|
      format.html { render 'edit', { :git_config => @git_config } }
    end
  end

  private

  def find_git_config
    @git_config = GitConfig.find(params[:id])
  end
end
