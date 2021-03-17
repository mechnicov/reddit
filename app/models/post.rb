class Post < ApplicationRecord
  belongs_to :author

  validates :title,
            :body,
            :score_dislikes,
            :score_unvoted,
            :score_likes,
            :url,
            :reddit_id,
            :comments_count,
            :posted_at,
            presence: true
end
