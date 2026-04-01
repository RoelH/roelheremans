ActiveAdmin.register Speaking do
  permit_params :text, :pic_url, :slug, :seo_title, :seo_description

  config.filters = false

  action_item :manage_logos, only: %i[index show edit] do
    if Speaking.admin_logo_backend_ready?
      link_to 'Manage Logos', admin_speaking_logos_path
    end
  end

  form do |f|
    f.inputs 'Speaking' do
      f.input :text
      f.input :pic_url
      f.input :slug
      f.input :seo_title
      f.input :seo_description
    end
    f.actions
  end

  show do
    attributes_table do
      row :text
      row :pic_url
      row :slug
      row :seo_title
      row :seo_description
      row :created_at
      row :updated_at
    end

    panel 'Speaking Logos' do
      if Speaking.admin_logo_backend_ready?
        table_for resource.speaking_logos.ordered do
          column :position
          column :name
          column :active
          column :destination_url
        end
      else
        para 'Speaking logos are unavailable until the logo and Active Storage tables exist in this environment.'
      end
    end
  end
end
