class AddTextToInnerPortrait < ActiveRecord::Migration[7.1]
  def change
    add_column :inner_portraits, :text, :text
  end
end
