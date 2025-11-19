class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.text :question_text, null: false
      t.timestamps
    end
  end
end
