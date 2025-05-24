require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:websites).dependent(:destroy) }
  
  it "is valid with valid attributes" do
    user = User.new(
      email: "test@example.com",
      password: "password"
    )
    expect(user).to be_valid
  end
end

