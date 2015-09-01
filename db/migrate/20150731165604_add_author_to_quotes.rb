class AddAuthorToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :author, :string
  end
end
