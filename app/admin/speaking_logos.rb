ActiveAdmin.register SpeakingLogo do
  permit_params :speaking_id, :name, :destination_url, :image_url, :alt_text, :link_label, :position, :active, :image

  menu priority: 7, label: 'Speaking Logos', if: proc { Speaking.admin_logo_backend_ready? }

  includes :speaking, image_attachment: :blob

  config.sort_order = 'position_asc'

  scope :all
  scope :active

  action_item :back_to_speaking, only: %i[index show edit new] do
    link_to 'Speaking Page Content', admin_speakings_path
  end

  member_action :move_up, method: :put do
    resource.move_higher!
    redirect_back fallback_location: admin_speaking_logos_path, notice: 'Logo moved up.'
  end

  member_action :move_down, method: :put do
    resource.move_lower!
    redirect_back fallback_location: admin_speaking_logos_path, notice: 'Logo moved down.'
  end

  index do
    selectable_column
    id_column
    column :position
    column :active
    column :name
    column :alt_text
    column :destination_url
    column :image_url
    column :link_label
    column :image do |logo|
      if logo.image_url.present?
        image_tag logo.image_url, style: 'max-height: 40px; width: auto;'
      elsif logo.image.attached?
        image_tag url_for(logo.image), style: 'max-height: 40px; width: auto;'
      end
    end
    actions defaults: true do |logo|
      links = []
      links << link_to('Up', move_up_admin_speaking_logo_path(logo), method: :put)
      links << link_to('Down', move_down_admin_speaking_logo_path(logo), method: :put)
      safe_join(links, ' | ')
    end
  end

  form do |f|
    f.inputs 'Speaking Logo' do
      speaking = Speaking.instance
      f.input :speaking, collection: [[speaking.slug.presence || 'Speaking', speaking.id]]
      f.input :name, hint: 'Internal/visible brand or institution name.'
      f.input :destination_url, hint: 'Full URL including https://'
      f.input :image_url, hint: 'Optional Cloudinary logo image URL. If present, this is used instead of the uploaded file.'
      f.input :alt_text, hint: 'Describe the institution shown by the logo.'
      f.input :link_label, hint: 'Optional extra accessible label for the link.'
      f.input :position, hint: 'Lower numbers appear first.'
      f.input :active
      f.input :image, as: :file, hint: (image_tag(f.object.image_source, style: 'max-height: 60px; width: auto;') if f.object.image_url.present? || f.object.image.attached?)
    end
    f.actions
  end

  show do
    attributes_table do
      row :speaking
      row :name
      row :destination_url
      row :image_url
      row :alt_text
      row :link_label
      row :position
      row :active
      row :image do |logo|
        if logo.image_url.present?
          image_tag logo.image_url, style: 'max-height: 90px; width: auto;'
        elsif logo.image.attached?
          image_tag url_for(logo.image), style: 'max-height: 90px; width: auto;'
        end
      end
      row :created_at
      row :updated_at
    end
  end

  filter :name
  filter :active
  filter :position
  filter :speaking

  controller do
    before_action :ensure_speaking_logo_backend_ready!

    def scoped_collection
      super.includes(:speaking, image_attachment: :blob).ordered
    end

    def create
      if params.dig(:speaking_logo, :speaking_id).blank?
        params[:speaking_logo][:speaking_id] = Speaking.instance.id
      end

      super
    end

    private

    def ensure_speaking_logo_backend_ready!
      return if Speaking.admin_logo_backend_ready?

      redirect_to admin_speaking_path(Speaking.safe_instance.id), alert: 'Speaking logos are unavailable until the logo migrations and Active Storage tables are present.'
    rescue StandardError
      redirect_to admin_root_path, alert: 'Speaking logos are unavailable until the logo migrations and Active Storage tables are present.'
    end
  end
end
