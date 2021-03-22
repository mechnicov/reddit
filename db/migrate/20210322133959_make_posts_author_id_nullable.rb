class MakePostsAuthorIdNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :posts, :author_id, true
  end
end
