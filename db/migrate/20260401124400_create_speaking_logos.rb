class CreateSpeakingLogos < ActiveRecord::Migration[7.1]
  def change
    create_table :speaking_logos do |t|
      t.references :speaking, null: false, foreign_key: true
      t.string :name, null: false
      t.string :destination_url
      t.string :alt_text, null: false
      t.string :link_label
      t.integer :position, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :speaking_logos, [:speaking_id, :position]
  end
end
