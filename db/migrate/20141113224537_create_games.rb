class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :word_id
      t.integer :tries_left, default: 11
      t.string :status
      t.timestamps
    end
  end
end
