class GitConfigsController < ApplicationController
  respond_to :html

  load_and_authorize_resource

  def edit
  end

  def show
    render 'edit', { :git_config => @git_config }
  end

  def update
    @git_config.update_attributes(params[:git_config])
    @git_config.save!
    flash[:notice] = t "Git configuration updated."
    respond_with(@git_config) do |format|
      format.html { render 'edit', { :git_config => @git_config } }
    end
  end

end
