require 'rails_helper'

RSpec.describe WebsiteScraperService do
  describe "#execute" do
    let(:user) { create(:user) }
    let(:website) { create(:website, user: user, url: "https://example.com") }
    
    context "when the request is successful" do
      before do
        html_content = <<-HTML
          <html>
            <head><title>Example Domain</title></head>
            <body>
              <a href="https://example.org">Example.org</a>
              <a href="https://example.net">Example.net</a>
            </body>
          </html>
        HTML
        
        stub_request(:get, "https://example.com")
          .to_return(status: 200, body: html_content)
      end
      
      it "extracts the title and links" do
        result = WebsiteScraperService.new(website).execute
        
        expect(result[:success]).to be true
        expect(result[:title]).to eq("Example Domain")
        expect(result[:links].count).to eq(2)
      end
      
      it "creates Link records" do
        expect {
          WebsiteScraperService.new(website).execute
        }.to change(Link, :count).by(2)
      end
    end
    
    context "when the request fails" do
      before do
        stub_request(:get, "https://example.com")
          .to_return(status: 404)
      end
      
      it "returns an error result" do
        result = WebsiteScraperService.new(website).execute
        
        expect(result[:success]).to be false
        expect(result[:error]).to include("HTTP Error")
      end
    end
  end
end

