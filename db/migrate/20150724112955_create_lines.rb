class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.references :transcription, index: true

      t.timestamps null: false
    end
    add_foreign_key :lines, :transcriptions
  end
end
