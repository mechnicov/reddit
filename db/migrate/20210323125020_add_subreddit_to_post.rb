class AddSubredditToPost < ActiveRecord::Migration[6.0]
  def change
    change_table :posts do |t|
      t.belongs_to :subreddit, foreign_key: true
    end
  end
end
