module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_id

    def connect
      self.session_id = request.session[:user_identity] || SecureRandom.uuid
      request.session[:user_identity] = session_id
    end
  end
end
