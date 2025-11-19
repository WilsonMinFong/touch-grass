// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// ActionCable setup
import consumer from "./channels/consumer"
window.App = { cable: consumer }

// Import room channel (auto-connects based on page data)
import "./channels/room_channel"
