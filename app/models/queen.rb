class Queen
	def self.attemptMove(to, from, board)
		if isValidMove?(to, from, board)
			board[to[0]][to[1]] = board[from[0]][from[1]]
			board[from[0]][from[1]] = ''
		end
		return board
	end

	def self.isValidMove?(to, from, board)
		return Bishop.isValidMove?(to, from, board) || Rook.isValidMove?(to, from, board)
	end
end