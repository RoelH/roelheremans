class InnerPortrait < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
end
