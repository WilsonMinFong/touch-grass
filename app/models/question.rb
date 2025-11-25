class Question < ApplicationRecord
  validates :question_text, presence: true, uniqueness: true

  def position
    Question.where("id <= ?", id).count
  end
end
