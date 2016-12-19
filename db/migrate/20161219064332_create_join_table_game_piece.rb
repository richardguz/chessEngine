class CreateJoinTableGamePiece < ActiveRecord::Migration[5.0]
  def change
    create_join_table :Games, :Pieces do |t|
      # t.index [:game_id, :piece_id]
      # t.index [:piece_id, :game_id]
    end
  end
end
