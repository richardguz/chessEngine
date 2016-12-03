class AddPlayer1TurnToGame < ActiveRecord::Migration[5.0]
  def change
  	add_column :games, :player1_turn, :boolean
  end
end
