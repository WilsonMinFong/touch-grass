class CreateResponseReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :response_reactions do |t|
      t.references :question_response, null: false, foreign_key: true
      t.string :session_id

      t.timestamps
    end
  end
end
