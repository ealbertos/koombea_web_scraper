class WebsiteScraperService
  attr_reader :website
  
  def initialize(website)
    @website = website
  end
  
  def execute
    response = HTTParty.get(website.url)
    
    if response.success?
      doc = Nokogiri::HTML(response.body)
      title = doc.at_css("title")&.text || website.url
      links = extract_links(doc)
      
      save_links(links)
      
      { success: true, title: title, links: links }
    else
      { success: false, error: "HTTP Error: #{response.code}" }
    end
  rescue => e
    Rails.logger.error("Error in WebsiteScraperService: #{e.message}")
    { success: false, error: e.message }
  end
  
  private
  
  def extract_links(doc)
    doc.css("a").map do |link|
      href = link["href"]
      absolute_url = convert_to_absolute_url(href) if href.present?
      
      {
        url: absolute_url,
        name: link.text.strip.presence || link.inner_html.truncate(100)
      }
    end.select { |link| link[:url].present? }
  end

  def convert_to_absolute_url(href)
    URI.join(website.url, href).to_s
  rescue URI::InvalidURIError
    href
  end
    
  def save_links(links)
    links.each do |link_data|
      website.links.create(
        url: link_data[:url],
        name: link_data[:name]
      )
    end
  end
end

