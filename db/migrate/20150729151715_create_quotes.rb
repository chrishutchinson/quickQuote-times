class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.float :tc_in
      t.float :tc_out
      t.float :duration
      t.text :text
      t.references :video, index: true

      t.timestamps null: false
    end
    add_foreign_key :quotes, :videos
  end
end
