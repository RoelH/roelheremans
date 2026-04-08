class Video < ApplicationRecord
  belongs_to :work, optional: true
  belongs_to :speaking, optional: true

  validates :url, presence: true
  validate :belongs_to_one_parent

  def self.ransackable_attributes(auth_object = nil)
    %w[url cover work_id speaking_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[work speaking]
  end

  def youtube_id
    return if url.blank?

    uri = URI.parse(url)

    if uri.host&.include?("youtu.be")
      uri.path.delete_prefix("/").split("/").first
    elsif uri.path.start_with?("/embed/", "/shorts/")
      uri.path.split("/")[2]
    else
      Rack::Utils.parse_nested_query(uri.query)["v"]
    end
  rescue URI::InvalidURIError
    url.split("=").last
  end

  def embed_url
    return if youtube_id.blank?

    "https://www.youtube-nocookie.com/embed/#{youtube_id}"
  end

  private

  def belongs_to_one_parent
    return if work.present? ^ speaking.present?

    errors.add(:base, "Video must belong to one parent")
  end
end
