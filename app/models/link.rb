class Link < ApplicationRecord
  belongs_to :website

  validates :url, presence: true
end
