class ProfilController < ApplicationController
  before_action :set_works

  def about
  end

  def speaking
    @speaking = Speaking.safe_instance
    @speaking_logos = @speaking.active_logos_for_frontend
    @speaking_videos = @speaking.videos_for_frontend
  end

  def cv
    @cv_categories = @profil.cv_categories.order(:id)
  end

  def contact
    @contacts = @profil.addresses.order(:id)

  end

end
