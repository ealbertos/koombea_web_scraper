require 'rails_helper'

RSpec.describe ScrapeWebsiteJob, type: :job do
  include ActiveJob::TestHelper
  
  let(:user) { create(:user) }
  let(:website) { create(:website, user: user) }
  
  it "calls the WebsiteScraperService" do
    service_double = instance_double(WebsiteScraperService)
    expect(WebsiteScraperService).to receive(:new).with(website).and_return(service_double)
    expect(service_double).to receive(:execute).and_return({ success: true, title: "Test", links: [] })
    
    ScrapeWebsiteJob.perform_now(website.id)
  end
  
  context "when scraping is successful" do
    before do
      allow_any_instance_of(WebsiteScraperService).to receive(:execute).and_return({
        success: true,
        title: "Test website",
        links: [{ url: "https://example.com", name: "Example" }]
      })
    end
    
    it "updates the website with the scraped information" do
      ScrapeWebsiteJob.perform_now(website.id)
      
      website.reload
      expect(website.title).to eq("Test website")
      expect(website.status).to eq("completed")
    end
  end
  
  context "when scraping fails" do
    before do
      allow_any_instance_of(WebsiteScraperService).to receive(:execute).and_return({
        success: false,
        error: "Failed to scrape"
      })
    end
    
    it "marks the website as failed" do
      ScrapeWebsiteJob.perform_now(website.id)
      
      website.reload
      expect(website.status).to eq("failed")
    end
  end
end

