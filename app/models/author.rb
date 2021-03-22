class Author < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name,
            :reddit_id,
            :post_karma,
            :comment_karma,
            :registered_at,
            presence: true
end
