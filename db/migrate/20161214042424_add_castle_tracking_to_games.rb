class AddCastleTrackingToGames < ActiveRecord::Migration[5.0]
  def change
  	add_column :games, :white_can_castle_king_side, :boolean, default: true
  	add_column :games, :black_can_castle_king_side, :boolean, default: true
  	add_column :games, :white_can_castle_queen_side, :boolean, default: true
  	add_column :games, :black_can_castle_queen_side, :boolean, default: true
  end
end
