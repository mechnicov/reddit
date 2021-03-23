class Subreddit < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name,
            :founded_at,
            :subscribers_count,
            presence: true
end
