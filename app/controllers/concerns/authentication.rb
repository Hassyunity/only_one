module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id])
  end

  def require_login!
    return if Current.user

    redirect_to new_session_path, alert: "Veuillez vous connecter."
  end

  def require_role!(*roles)
    return if Current.user&.role.in?(roles.map(&:to_s)) || Current.user&.direction?

    redirect_to Current.user.home_path, alert: "Vous n'avez pas accès à cet espace."
  end
end
