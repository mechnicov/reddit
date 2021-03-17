class CreatePostsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.bigint :score_dislikes, null: false, default: 0
      t.bigint :score_unvoted, null: false, default: 0
      t.bigint :score_likes, null: false, default: 0
      t.string :url, null: false
      t.string :reddit_id, null: false
      t.integer :comments_count, null: false, default: 0
      t.datetime :posted_at, null: false

      t.belongs_to :author, foreign_key: true, null: false

      t.timestamps
    end
  end
end
