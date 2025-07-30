ActiveAdmin.register InnerPortrait do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :slug, :url, :password
  #
  # or
  #
  # permit_params do
  #   permitted = [:slug, :url, :password]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :slug, :url, :password

  index do
    selectable_column
    id_column
    column "Name", :slug
    column :url
    column :password do |inner_portrait|
      inner_portrait.password.present? ? inner_portrait.password : "No password"
    end
    actions
  end

  form do |f|
    f.inputs do

      f.input :slug, label: "name"
      f.input :url
      f.input :password, as: :string
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row "Name" do |inner_portrait|
      inner_portrait.slug
    end
      row :url
      row :password do |inner_portrait|
        inner_portrait.password.present? ? inner_portrait.password : "No password"
      end
      row :created_at
      row :updated_at
    end
   
  end

end
