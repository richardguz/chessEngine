class AddBoardToGame < ActiveRecord::Migration[5.0]
  def change
  	add_column :games, :board, :json
  end
end
