ActiveAdmin.register Speaking do
  permit_params :text, :pic_url, :slug, :seo_title, :seo_description

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

  filter :text
end
