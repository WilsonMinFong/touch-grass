class Room < ApplicationRecord
  validates :code, presence: true, uniqueness: true, length: { maximum: 6 }
  validates :name, presence: true
  validates :session_id, presence: true

  before_validation :generate_code, on: :create

  scope :for_session, ->(session_id) { where(session_id: session_id) }

  has_many :room_presences, dependent: :destroy
  has_many :active_participants, -> { active }, class_name: "RoomPresence"
  has_many :question_responses

  # Use the code instead of id in URLs
  def to_param
    code
  end

  def join_session(session_id)
    presence = room_presences.find_or_create_by(session_id: session_id)
    presence.touch_presence!
    presence
  end

  def leave_session(session_id)
    room_presences.find_by(session_id: session_id)&.destroy
  end

  def active_participants_count
    active_participants.count
  end

  def is_owner?(session_id)
    self.session_id == session_id
  end

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
