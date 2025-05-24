class WebsitesController < ApplicationController
  before_action :require_login
  before_action :set_website, only: [:show]
  
  def index
    @websites = current_user.websites.ordered.page(params[:page])
    @website = Website.new
  end
  
  def show
    @links = @website.links.page(params[:page])
  end
  
  def create
    @website = current_user.websites.build(website_params)

    if @website.save
     ScrapeWebsiteJob.perform_later(@website.id)
      redirect_to websites_path, notice: "The website is being processed."
    else
      @websites = current_user.websites.ordered.page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end

  
  private
  
  def set_website
    @website = current_user.websites.find(params[:id])
  end
  
  def website_params
    params.require(:website).permit(:url)
  end
end

