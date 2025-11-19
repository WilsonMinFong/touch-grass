class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find_by(code: params[:room_code])
    return reject unless room

    stream_for room

    # Join the room when subscribing
    room.join_session(session_id)

    # Broadcast that someone joined
    broadcast_to room, {
      type: "user_joined",
      participants_count: room.active_participants_count
    }
  end

  def unsubscribed
    room = Room.find_by(code: params[:room_code])
    return unless room

    # Leave the room when unsubscribing
    room.leave_session(session_id)

    # Broadcast that someone left
    broadcast_to room, {
      type: "user_left",
      participants_count: room.active_participants_count
    }
  end

  def heartbeat
    room = Room.find_by(code: params[:room_code])
    return unless room

    room.join_session(session_id)

    # Only broadcast aggregate data
    broadcast_to room, {
      type: "heartbeat",
      participants_count: room.active_participants_count
    }
  end

  private

  def session_id
    connection.session_id
  end
end
