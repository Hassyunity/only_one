class HomeController < ApplicationController
  def index
    redirect_to(Current.user ? Current.user.home_path : new_session_path)
  end
end
