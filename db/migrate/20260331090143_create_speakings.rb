class CreateSpeakings < ActiveRecord::Migration[7.1]
  def change
    create_table :speakings do |t|
      t.text :text
      t.string :pic_url
      t.string :slug, default: "speaking"
      t.string :seo_title
      t.text :seo_description

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # We use execute to avoid model dependency issues, but since it's a simple setup we can just use the models
        # if we define them locally to avoid future breakages, but here ActiveRecord will suffice.
        Speaking.reset_column_information
        if Profil.table_exists? && Profil.any?
          p = Profil.first
          Speaking.create!(
            text: p.about,
            pic_url: p.pic_url
          )
        else
          Speaking.create!(
            text: "Speaking content placeholder",
            pic_url: ""
          )
        end
      end
    end
  end
end
