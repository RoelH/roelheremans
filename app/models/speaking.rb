class Speaking < ApplicationRecord
  has_many :speaking_logos, -> { order(:position, :id) }, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[id text pic_url slug seo_title seo_description created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[speaking_logos]
  end

  def self.instance
    first_or_create!
  end

  def self.safe_instance
    return fallback_instance unless table_available?

    instance
  rescue ActiveRecord::ActiveRecordError
    fallback_instance
  end

  def self.table_available?
    connection.data_source_exists?(table_name)
  rescue ActiveRecord::ActiveRecordError
    false
  end

  def self.logos_available?
    connection.data_source_exists?("speaking_logos") &&
      connection.data_source_exists?("active_storage_blobs") &&
      connection.data_source_exists?("active_storage_attachments")
  rescue ActiveRecord::ActiveRecordError
    false
  end

  def self.admin_logo_backend_ready?
    table_available? && logos_available?
  end

  def active_logos_for_frontend
    return SpeakingLogo.none unless self.class.logos_available?

    speaking_logos.active.ordered.with_attached_image
  rescue ActiveRecord::ActiveRecordError
    SpeakingLogo.none
  end

  def self.fallback_instance
    profil = Profil.first

    new(
      text: profil&.about.to_s,
      pic_url: profil&.pic_url.to_s,
      slug: "speaking"
    )
  end
end
