class CreatePromptSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :prompt_submissions do |t|
      t.string :name
      t.string :email
      t.text :prompt_text, null: false
      t.text :answer_text

      t.timestamps
    end
  end
end
