class HomeController < ApplicationController
 before_action :require_login 

  def index
    redirect_to websites_path if signed_in?
  end
end
