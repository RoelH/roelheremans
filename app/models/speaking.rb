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
end
