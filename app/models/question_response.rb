class QuestionResponse < ApplicationRecord
  belongs_to :question
  belongs_to :room

  validates :response_text, :session_id, presence: true

  validates :session_id, uniqueness: {
    scope: [ :room_id, :question_id ],
    message: "has already responded to this question in this room"
  }

  has_many :response_reactions, dependent: :destroy

  def liked_by?(session_id)
    response_reactions.exists?(session_id: session_id)
  end
end
