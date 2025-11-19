class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :ensure_session_identity

  private

  def ensure_session_identity
    session[:user_identity] ||= SecureRandom.uuid
  end

  def current_session_id
    session[:user_identity]
  end
end
