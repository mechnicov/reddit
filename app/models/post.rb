class Post < ApplicationRecord
  belongs_to :author, optional: true

  validates :title,
            :body,
            :score,
            :upvoted,
            :url,
            :short_url,
            :reddit_id,
            :comments_count,
            :posted_at,
            presence: true
end
