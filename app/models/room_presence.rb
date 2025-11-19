# app/models/room_presence.rb
class RoomPresence < ApplicationRecord
  belongs_to :room
  validates :session_id, presence: true, uniqueness: { scope: :room_id }

  # Consider someone active if they've been seen in the last 30 seconds
  scope :active, -> { where("last_seen > ?", 30.seconds.ago) }

  def self.cleanup_stale_sessions
    where("last_seen < ?", 2.minutes.ago).delete_all
  end

  def touch_presence!
    update!(last_seen: Time.current)
  end
end
