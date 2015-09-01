class AddLinkToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :link, :string
  end
end
