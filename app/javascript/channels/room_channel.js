import consumer from "./consumer"

// Auto-connect to room channel when page has room data
document.addEventListener('DOMContentLoaded', function () {
  const roomElement = document.querySelector('[data-room-code]')
  if (roomElement) {
    const roomCode = roomElement.dataset.roomCode
    connectToRoom(roomCode)
  }
})

// Connect to RoomChannel for real-time presence updates
function connectToRoom(roomCode) {
  console.log(`Connecting to room: ${roomCode}`)

  const subscription = consumer.subscriptions.create(
    { channel: "RoomChannel", room_code: roomCode },
    {
      connected() {
        console.log(`Connected to room: ${roomCode}`)
      },

      disconnected() {
        console.log(`Disconnected from room: ${roomCode}`)
      },

      received(data) {
        console.log("Received data:", data)

        // Update participant count in real-time
        const countElement = document.getElementById('participants-count')
        if (countElement && data.participants_count !== undefined) {
          countElement.textContent = data.participants_count
        }

        // Handle different event types
        switch (data.type) {
          case 'user_joined':
            console.log('Someone joined the room')
            break
          case 'user_left':
            console.log('Someone left the room')
            break
          case 'heartbeat':
            // Heartbeat updates
            break
          case 'new_response':
            console.log('New response received')
            document.dispatchEvent(new CustomEvent('room:new_response', { detail: data }))
            break
          case 'reaction_update':
            console.log('Reaction update received')
            document.dispatchEvent(new CustomEvent('room:reaction_update', { detail: data }))
            break
          case 'next_question':
            console.log('Next question received')
            window.location.reload()
            break
        }
      },

      // Send heartbeat to maintain presence
      sendHeartbeat() {
        this.perform('heartbeat')
      }
    }
  )

  // Send periodic heartbeats to maintain presence
  const heartbeatInterval = setInterval(() => {
    subscription.sendHeartbeat()
  }, 30000) // Every 30 seconds

  // Cleanup on page unload
  window.addEventListener('beforeunload', () => {
    clearInterval(heartbeatInterval)
    subscription.unsubscribe()
  })

  return subscription
}

export { connectToRoom }