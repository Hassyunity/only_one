class SessionsController < ApplicationController
  def new
    redirect_to Current.user.home_path if Current.user
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user.home_path, notice: "Bienvenue #{user.name}."
    else
      flash.now[:alert] = "Email ou mot de passe incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path
  end
end
