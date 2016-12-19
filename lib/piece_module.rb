module PieceModule
	def take_piece(piece, game)
		if (p = Piece.find_by(:representation => piece))
			game.pieces >> p
		else
			p = Piece.create(:representation => piece)
			game.pieces >> p
		end
	end
end