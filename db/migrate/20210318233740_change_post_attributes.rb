class ChangePostAttributes < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :score_dislikes, :bigint, null: false, default: 0
    remove_column :posts, :score_unvoted, :bigint, null: false, default: 0
    remove_column :posts, :score_likes, :bigint, null: false, default: 0

    add_column :posts, :score, :integer, null: false, default: 0
    add_column :posts, :upvoted, :smallint, null: false, default: 0
    add_column :posts, :short_url, :string, null: false
  end
end
