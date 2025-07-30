class InnerPortrait < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :password, presence: true
  before_save :downcase

  def self.ransackable_attributes(auth_object = nil)
    %w[id slug url password created_at updated_at]
  end

  def downcase
    self.slug = slug.downcase if slug.present?


  end
end
