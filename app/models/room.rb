class Room < ApplicationRecord
  validates :code, presence: true, uniqueness: true, length: { maximum: 6 }
  validates :name, presence: true

  before_validation :generate_code, on: :create

  private

  def generate_code
    return if code.present?

    loop do
      self.code = generate_random_code
      break unless Room.exists?(code: code)
    end
  end

  def generate_random_code
    # Generate 6-character alphanumeric code (uppercase letters and numbers)
    chars = ("A".."Z").to_a + (0..9).to_a
    6.times.map { chars.sample }.join
  end
end
