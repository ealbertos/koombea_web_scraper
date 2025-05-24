require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:website) }
  it { should validate_presence_of(:url) }
  
  it "is valid with valid attributes" do
    user = create(:user)
    website = create(:website, user: user)
    link = Link.new(url: "https://example.com", name: "Example", website: website)
    expect(link).to be_valid
  end
end


