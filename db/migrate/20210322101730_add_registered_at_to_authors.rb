class AddRegisteredAtToAuthors < ActiveRecord::Migration[6.0]
  def change
    change_table :authors do |t|
      t.date :registered_at, null: false
    end
  end
end
