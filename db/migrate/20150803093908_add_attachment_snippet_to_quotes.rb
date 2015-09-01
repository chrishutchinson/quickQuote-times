class AddAttachmentSnippetToQuotes < ActiveRecord::Migration
  def self.up
    change_table :quotes do |t|
      t.attachment :snippet
    end
  end

  def self.down
    remove_attachment :quotes, :snippet
  end
end
