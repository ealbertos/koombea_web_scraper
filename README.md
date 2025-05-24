# Web Scraper

## Features

- User registration and authentication
- Website scanning to extract links
- Background processing with Sidekiq
- Pagination with Kaminari

## Requirements

- Ruby 3.3.0
- Rails 8.0.0
- PostgreSQL
- Redis (for Sidekiq)
- Node.js and Yarn (for asset compilation)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/ealbertos/koombea_web_scraper.git
cd koombea_web_scraper
```

2. Install dependencies:
```bash
bundle install
yarn install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
```

4. Start the servers:
```bash
# Preferre method
bin/dev

# If you want to run separate servers
yarn build:css #Just the first time
rails server
bundle exec sidekiq
```

5. Visit `http://localhost:3000` in your browser

## Usage

1. Sign up or log in to the application
2. On the home page, enter the URL of the website you want to scrape
3. Click "Scrape" to start the process
4. The website will be processed in the background
5. Click the name of the website to see all the links found on it

## Architecture

### Models
- `User`: Manages user authentication (using Clearance)
- `Website`: Stores information about scraped websites
- `Link`: Stores links found on scraped websites

### Controllers
- `HomeController`: The root path that shows if the user is logged in or not
- `WebsitesController`: Manages website scrping and viewing

### Services
- `WebsiteScraperService`: Handles the web scraping logic

### Jobs
- `ScrapeWebsiteJob`: Processes website scraping in the background

## Testing

To run the tests:
```bash
bundle exec rspec
```

The test suite includes:
- Model tests
- Controller tests
- Service tests
- Job tests

## Tools Used

- **Rails 8.0.0**
- **PostgreSQL**
- **Clearance**: User authentication
- **Sidekiq**: Background job processing
- **Nokogiri**: HTML parsing
- **HTTParty**: HTTP requests
- **Bootstrap 5**: CSS framework
- **Kaminari**: Pagination
- **RSpec**
- **FactoryBot**
- **Faker**
- **WebMock**
