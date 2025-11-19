class CreateQuestionResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :question_responses do |t|
      t.references :question, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.string :session_id, null: false
      t.text :response_text, null: false

      t.timestamps
    end

    add_index :question_responses, [ :room_id, :question_id, :session_id ], unique: true,
              name: 'index_question_responses_unique_per_session'
  end
end
