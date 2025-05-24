require 'rails_helper'

RSpec.describe WebsitesController, type: :controller do
  let(:user) { create(:user) }

  before do
    controller.session[:clearance] = user.id
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:signed_in?).and_return(true)
    controller.params[:website] = nil
  end


  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end
  
  describe "GET #show" do
    it "returns a success response" do
      website = create(:website, user: user)
      get :show, params: { id: website.id }
      expect(response).to be_successful
    end
  end
  
  describe "POST #create" do
    context "with valid params" do
      it "creates a new website" do
        expect {
          post :create, params: { website: { url: "https://example.com" } }
        }.to change(Website, :count).by(1)
      end
      
      it "enqueues a scrape job" do
        expect {
          post :create, params: { website: { url: "https://example.com" } }
        }.to have_enqueued_job(ScrapeWebsiteJob)
      end
      
      it "redirects to the websites list" do
        post :create, params: { website: { url: "https://example.com" } }
        expect(response).to redirect_to(websites_path)
      end
    end

    context "with invalid params" do
      it "does not create a new website" do
        expect {
          post :create, params: { website: { url: "invalid-url" } }
        }.to change(Website, :count).by(0)
      end
    end
  end
end

