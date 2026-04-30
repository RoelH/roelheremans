module ApplicationHelper
  CLOUDINARY_IMAGE_UPLOAD_SEGMENT = "/image/upload/".freeze

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
