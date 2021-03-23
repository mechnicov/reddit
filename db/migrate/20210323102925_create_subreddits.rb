class CreateSubreddits < ActiveRecord::Migration[6.0]
  def change
    create_table :subreddits do |t|
      t.string :name, null: false
      t.integer :subscribers_count, null: false, default: 0
      t.datetime :founded_at, null: false

      t.timestamps
    end
  end
end
