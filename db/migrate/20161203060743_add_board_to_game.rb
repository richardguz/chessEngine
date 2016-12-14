class AddBoardToGame < ActiveRecord::Migration[5.0]
  def change
  	add_column :games, :board, :json
  	add_column :games, :en_passant, :json
  end
end
