class CreateAuthorsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.string :reddit_id, null: false
      t.integer :post_karma, null: false, default: 0
      t.integer :comment_karma, null: false, default: 0

      t.timestamps
    end
  end
end
