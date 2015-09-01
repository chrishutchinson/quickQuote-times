class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.float :tc_in
      t.float :tc_out
      t.string :word
      t.references :line, index: true

      t.timestamps null: false
    end
    add_foreign_key :words, :lines
  end
end
