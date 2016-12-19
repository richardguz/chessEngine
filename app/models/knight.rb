class Knight
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
		x1 = from[0]
		x2 = to[0]
		y1 = from[1]
		y2 = to[1]

		xDiff = (x2 - x1).abs
		yDiff = (y2 - y1).abs

		if xDiff == 1 && yDiff == 2
			return true
		elsif xDiff == 2 && yDiff == 1
			return true
		else
			return false
		end
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