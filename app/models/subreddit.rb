class Subreddit < ApplicationRecord
  validates :name,
            :founded_at,
            :subscribers_count,
            presence: true
end
