class Speaking < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[id text pic_url slug seo_title seo_description created_at updated_at]
  end

  def self.instance
    first_or_create!
  end
end
