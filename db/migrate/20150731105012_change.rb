class Change < ActiveRecord::Migration
  def change
    def self.up
      change_table :video do |t|
        t.change :uid, :bignum
      end
    end
    def self.down
      change_table :video do |t|
        t.change :uid, :int
      end
    end
  end
end
