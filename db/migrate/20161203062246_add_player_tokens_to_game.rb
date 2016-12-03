class AddPlayerTokensToGame < ActiveRecord::Migration[5.0]
  def change
  	add_column :games, :player1_token, :string
  	add_column :games, :player2_token, :string
  end
end
