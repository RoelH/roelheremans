class InnerPortrait < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true, format: { with: /\Ahttps:\/\/res\.cloudinary\.com\/.*\.mp3\z/i, message: "must be a valid Cloudinary URL ending with .mp3" }


  before_save :downcase

  def self.ransackable_attributes(auth_object = nil)
    %w[id slug url password text created_at updated_at]
  end

  def downcase
    self.slug = slug.downcase if slug.present?


  end
end
