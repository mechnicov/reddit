class MakePostsSubredditIdNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :posts, :subreddit_id, false
  end
end
