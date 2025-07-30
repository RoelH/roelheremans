class AddPasswordToInnerPortrait < ActiveRecord::Migration[7.1]
  def change
    add_column :inner_portraits, :password, :string
    add_index :inner_portraits, :slug
  end
end
