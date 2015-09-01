class AddIsProcessedToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :is_processed, :boolean
  end
end
