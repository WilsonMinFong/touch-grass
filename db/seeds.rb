# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  { question_text: "How are you?", placeholder: "Today my vibes are..." },
  { question_text: "What brings you here?", placeholder: "I'm here for..." },
  { question_text: "What's hard today?", placeholder: "I'm struggling with..." }
].each do |question_obj|
  Question.find_or_create_by!(question_text: question_obj[:question_text], placeholder: question_obj[:placeholder])
end
