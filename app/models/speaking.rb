class Speaking < ApplicationRecord
  has_many :speaking_logos, -> { order(:position, :id) }, dependent: :destroy
  has_many :videos, dependent: :destroy

  accepts_nested_attributes_for :videos, allow_destroy: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id text pic_url slug seo_title seo_description created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[speaking_logos videos]
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

  def self.videos_available?
    connection.data_source_exists?("videos") &&
      connection.column_exists?("videos", "speaking_id")
  rescue ActiveRecord::ActiveRecordError
    false
  end

  def self.admin_logo_backend_ready?
    table_available? && logos_available?
  end

  def self.admin_video_backend_ready?
    table_available? && videos_available?
  end

  def self.admin_backend_ready?
    table_available?
  end

  def active_logos_for_frontend
    return SpeakingLogo.none unless self.class.logos_available?

    speaking_logos.active.ordered.with_attached_image
  rescue ActiveRecord::ActiveRecordError
    SpeakingLogo.none
  end

  def videos_for_frontend
    return Video.none unless self.class.videos_available?

    videos.order(:id)
  rescue ActiveRecord::ActiveRecordError
    Video.none
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
