namespace :speaking do
  desc "Import logo files from ./logos into SpeakingLogo records"
  task import_logos: :environment do
    speaking = Speaking.instance
    logos_path = Rails.root.join("logos")

    unless logos_path.directory?
      abort "No logos directory found at #{logos_path}"
    end

    Dir.glob(logos_path.join("*")).sort.each do |file_path|
      next unless File.file?(file_path)

      basename = File.basename(file_path).sub(/\..*\z/, "")
      title = basename.tr("_-", " ").squish.titleize
      logo = speaking.speaking_logos.find_or_initialize_by(name: title)

      logo.alt_text = title
      logo.position ||= speaking.speaking_logos.where.not(id: logo.id).maximum(:position).to_i + 1
      logo.active = false if logo.destination_url.blank?

      unless logo.image.attached?
        File.open(file_path) do |file|
          logo.image.attach(
            io: file,
            filename: File.basename(file_path),
            content_type: Marcel::MimeType.for(Pathname.new(file_path))
          )
        end
      end

      logo.save!
    end

    puts "Imported #{speaking.speaking_logos.count} speaking logos. Inactive logos need URLs before activation."
  end
end
