class AddCurrentQuestionIdToRooms < ActiveRecord::Migration[8.1]
  def change
    add_reference :rooms, :current_question, null: true, foreign_key: { to_table: :questions }
  end
end
