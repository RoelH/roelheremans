class WorksController < ApplicationController

  def index
    @works = Work.includes(:photos, :videos).order(year: :desc)

  end

  def show
    @works = Work.select(:id, :title, :year, :slug).order(year: :desc)
    @work = Work.includes(:photos, :videos).friendly.find(params[:id])
    # render 'works/show'

  end
end
