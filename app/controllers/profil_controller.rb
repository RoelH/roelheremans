class ProfilController < ApplicationController
  before_action :set_works

  def about
  end

  def speaking
    @speaking = Speaking.instance
    @speaking_logos = @speaking.speaking_logos.active.ordered.with_attached_image
  end

  def cv
    @cv_categories = @profil.cv_categories.order(:id)
  end

  def contact
    @contacts = @profil.addresses.order(:id)

  end

end
