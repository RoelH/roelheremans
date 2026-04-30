class ApplicationController < ActionController::Base
  before_action :set_profil
  before_action :cache_public_get_pages


  def set_work
    @work = Work.friendly.find(params[:id])
  end

  private


  def set_profil
    @profil = Profil.first
  end


  def set_works
    @works = Work.select(:id, :title, :year, :slug).order(year: :desc)
  end

  def newsletter
  end

  def cache_public_get_pages
    return unless request.get? || request.head?
    return if request.path.start_with?("/admin", "/admin_users", "/prompt", "/innerportrait")

    request.session_options[:skip] = true
    expires_in 5.minutes, public: true
  end

end
