class CreateInnerPortraits < ActiveRecord::Migration[7.1]
  def change
    create_table :inner_portraits do |t|
      t.string :slug
      t.string :url
      t.timestamps
    end
  end
end
