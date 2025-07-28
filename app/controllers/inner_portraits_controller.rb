class InnerPortraitsController < ApplicationController
before_action :set_works

  def show
    @inner_portrait = InnerPortrait.find_by(slug: params[:slug])
    if @inner_portrait
      render :show
    else
      redirect_to root_path, alert: "Inner portrait not found."
    end
  end
end
