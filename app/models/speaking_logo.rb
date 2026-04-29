class SpeakingLogo < ApplicationRecord
  belongs_to :speaking

  has_one_attached :image

  scope :ordered, -> { order(:position, :id) }
  scope :active, -> { where(active: true) }

  before_validation :normalize_text_fields
  before_validation :assign_position, on: :create
  before_validation :clamp_position
  before_save :reposition_siblings, if: :will_save_change_to_position?
  after_destroy :close_position_gap

  validates :name, presence: true
  validates :alt_text, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :destination_url,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid HTTP(S) URL" },
            allow_blank: true
  validates :image_url,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid HTTP(S) URL" },
            allow_blank: true
  validate :image_source_present
  validate :active_logos_need_destination_url

  def self.ransackable_attributes(auth_object = nil)
    %w[id speaking_id name destination_url image_url alt_text link_label position active created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[image_attachment image_blob speaking]
  end

  def move_higher!
    return if position <= 1

    update!(position: position - 1)
  end

  def move_lower!
    return if position >= max_position

    update!(position: position + 1)
  end

  def image_source
    image_url.presence || image
  end

  private

  def normalize_text_fields
    self.name = name.to_s.squish
    self.alt_text = alt_text.to_s.squish
    self.link_label = link_label.to_s.squish.presence
    self.destination_url = destination_url.to_s.strip.presence
    self.image_url = image_url.to_s.strip.presence
  end

  def assign_position
    return if position.present?

    self.position = max_position + 1
  end

  def clamp_position
    return if position.blank?

    self.position = position.to_i
    self.position = 1 if position < 1
    self.position = [position, max_position + (new_record? ? 1 : 0)].min
  end

  def reposition_siblings
    return unless speaking_id

    sibling_scope = speaking.speaking_logos.where.not(id: id)

    self.class.transaction do
      if new_record?
        sibling_scope.where("position >= ?", position).update_all("position = position + 1")
      else
        old_position = position_in_database
        return if old_position.blank? || old_position == position

        if position < old_position
          sibling_scope.where(position: position...old_position).update_all("position = position + 1")
        else
          sibling_scope.where(position: (old_position + 1)..position).update_all("position = position - 1")
        end
      end
    end
  end

  def close_position_gap
    speaking.speaking_logos.where("position > ?", position).update_all("position = position - 1")
  end

  def max_position
    return 0 unless speaking

    speaking.speaking_logos.where.not(id: id).maximum(:position).to_i
  end

  def active_logos_need_destination_url
    return unless active? && destination_url.blank?

    errors.add(:destination_url, "can't be blank for active logos")
  end

  def image_source_present
    return if image_url.present? || image.attached?

    errors.add(:base, "Logo must have an uploaded image or image URL")
  end
end
