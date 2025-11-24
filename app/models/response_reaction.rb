class ResponseReaction < ApplicationRecord
  belongs_to :question_response

  validates :session_id, presence: true, uniqueness: { scope: :question_response_id }
end
