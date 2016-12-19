class Queen
	include PieceModule
	def self.attemptMove(to, from, game)
		board = JSON.parse(game.board)['board']
		if isValidMove?(to, from, board)
			cell_attacked = board[to[0]][to[1]]
			if cell_attacked != ''
				take_piece(cell_attacked, game)
			end
			board[to[0]][to[1]] = board[from[0]][from[1]]
			board[from[0]][from[1]] = ''
		end
		return board
	end

	def self.isValidMove?(to, from, board)
		return Bishop.isValidMove?(to, from, board) || Rook.isValidMove?(to, from, board)
	end

	def self.take_piece(piece, game)
		if (p = Piece.find_by(:representation => piece))
			game.pieces << p
		else
			p = Piece.create(:representation => piece)
			game.pieces << p
		end
	end
end