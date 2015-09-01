class CreateTranscriptions < ActiveRecord::Migration
  def change
    create_table :transcriptions do |t|
      t.string :name
      t.text :description
      t.references :video, index: true

      t.timestamps null: false
    end
    add_foreign_key :transcriptions, :videos
  end
end
