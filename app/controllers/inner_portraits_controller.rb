class InnerPortraitsController < ApplicationController
  before_action :set_works
  before_action :set_inner_portrait, only: [:show,:check_password]

  def show
    if @inner_portrait.password == ""
      @authorized_audio = true
    else
      @authorized_audio = session[:authorized_slugs]&.include?(@inner_portrait.slug)
    end
   render_or_redirect(:show)
  end


  def check_password
    if @inner_portrait && @inner_portrait.password == params[:password]
      session[:authorized_slugs] ||= []
      session[:authorized_slugs] << @inner_portrait.slug
      redirect_to inner_portrait_path(@inner_portrait.slug)
    else
      redirect_to inner_portrait_path(@inner_portrait.slug), alert: "Incorrect password."
    end

  end

  private
   def set_inner_portrait
    @inner_portrait = InnerPortrait.find_by(slug: params[:slug])
    end

    def render_or_redirect(view)
      if @inner_portrait
        render view
      else
        redirect_to root_path, alert: "Inner portrait not found."
      end
    end


end
