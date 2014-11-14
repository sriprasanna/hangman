class AddCurrentWordStatusToGame < ActiveRecord::Migration
  def change
    add_column :games, :current_word_status, :string
  end
end