class QuestionResponse < ApplicationRecord
  belongs_to :question
  belongs_to :room

  validates :response_text, :session_id, presence: true

  validates :session_id, uniqueness: {
    scope: [ :room_id, :question_id ],
    message: "has already responded to this question in this room"
  }
end
