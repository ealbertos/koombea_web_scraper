require 'rails_helper'

RSpec.describe Website, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  
  it "is invalid without a URL" do
    user = create(:user)
    website = Website.new(url: "", user: user)

    expect(website).not_to be_valid
    expect(website.errors[:url]).to include("Can't be blank")
  end


  it "is valid with a valid URL" do
    user = create(:user)
    website = Website.new(url: "https://example.com", user: user)
    expect(website).to be_valid
  end
  
  it "is invalid with an invalid URL" do
    user = create(:user)
    website = Website.new(url: "invalid-url", user: user)
    expect(website).not_to be_valid
  end

  describe "status enum" do
    it { should define_enum_for(:status).with_values(pending: 0, processing: 1, completed: 2, failed: 3) }
  end
end

