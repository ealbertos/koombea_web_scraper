class User < ApplicationRecord
  include Clearance::User

  has_many :websites, dependent: :destroy
end
