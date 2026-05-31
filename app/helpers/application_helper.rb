module ApplicationHelper
  CLOUDINARY_IMAGE_UPLOAD_SEGMENT = "/image/upload/".freeze
  DEFAULT_META_TITLE = "Roel Heremans | Neurotechnology Artist and Keynote Speaker".freeze
  DEFAULT_META_DESCRIPTION = "Roel Heremans is a neurotechnology artist and keynote speaker on neurorights, brain-computer interfaces, mental privacy, AI, and the future of human experience.".freeze
  PERSON_SCHEMA = {
    "@context" => "https://schema.org",
    "@type" => "Person",
    "@id" => "https://www.roelheremans.com/#person",
    "name" => "Roel Heremans",
    "url" => "https://www.roelheremans.com/",
    "jobTitle" => ["Neurotechnology Artist", "Keynote Speaker"],
    "hasOccupation" => [
      { "@type" => "Occupation", "name" => "Neurotechnology Artist" },
      { "@type" => "Occupation", "name" => "Keynote Speaker" }
    ],
    "homeLocation" => [
      { "@type" => "Place", "name" => "Brussels, Belgium" },
      { "@type" => "Place", "name" => "Stockholm, Sweden" }
    ],
    "sameAs" => ["https://www.wikidata.org/wiki/Q140002789"]
  }.freeze

  def default_meta_title
    DEFAULT_META_TITLE
  end

  def default_meta_description
    DEFAULT_META_DESCRIPTION
  end

  def person_schema_json
    json_escape(PERSON_SCHEMA.to_json)
  end

  def cloudinary_delivery_url(url, width: nil, height: nil, crop: nil)
    source = url.to_s
    return url if source.blank? || !source.include?(CLOUDINARY_IMAGE_UPLOAD_SEGMENT)

    transformations = ["f_auto", "q_auto"]
    transformations << "w_#{width}" if width.present?
    transformations << "h_#{height}" if height.present?
    transformations << "c_#{crop}" if crop.present?

    insert_cloudinary_transformations(source, transformations.join(","))
  end

  private

  def insert_cloudinary_transformations(source, transformations)
    prefix, suffix = source.split(CLOUDINARY_IMAGE_UPLOAD_SEGMENT, 2)
    upload_prefix = "#{prefix}#{CLOUDINARY_IMAGE_UPLOAD_SEGMENT}"

    if suffix.match?(/\Av\d+\//)
      "#{upload_prefix}#{transformations}/#{suffix}"
    elsif (match = suffix.match(%r{\A(.+)/(v\d+/.*)\z}))
      "#{upload_prefix}#{match[1]}/#{transformations}/#{match[2]}"
    else
      "#{upload_prefix}#{transformations}/#{suffix}"
    end
  end
end
