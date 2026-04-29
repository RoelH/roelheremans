class AddImageUrlToSpeakingLogos < ActiveRecord::Migration[7.1]
  def change
    add_column :speaking_logos, :image_url, :string
  end
end
