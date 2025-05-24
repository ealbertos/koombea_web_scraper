class Website < ApplicationRecord
  belongs_to :user
  has_many :links, dependent: :destroy
  
  validates :url,
    presence: { message: "Can't be blank" },
    format: {
      with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
      message: "it most be a valid URL with http o https"
    }
  
  enum :status, [ :pending, :processing, :completed, :failed ]
  
  scope :ordered, -> { order(created_at: :desc) }
end
