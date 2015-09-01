class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :link
      t.string :title
      t.datetime :published_at
      t.string :uid
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :videos, :uid
    add_foreign_key :videos, :users
  end
end
