class ScrapeWebsiteJob < ApplicationJob
  queue_as :default
  
  def perform(website_id)
    website = Website.find_by(id: website_id)
    return unless website
    
    begin
      website.update(status: :processing)
      
      result = WebsiteScraperService.new(website).execute
      
      if result[:success]
        website.update(
          title: result[:title],
          total_links: result[:links].count,
          status: :completed
        )

      else
        website.update(status: :failed)
      end
    rescue => e
      Rails.logger.error("Error scrapping website id: #{website_id}: #{e.message}")
      website.update(status: :failed)
    end
  end
end

