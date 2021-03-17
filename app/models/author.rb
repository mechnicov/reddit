class Author < ApplicationRecord
  validates :name,
            :reddit_id,
            :post_karma,
            :comment_karma,
            presence: true
end
