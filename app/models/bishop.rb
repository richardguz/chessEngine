class Bishop
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

		xdiff = x2 - x1
		ydiff = y2 - y1

		#if not diagonal movement
		if ydiff.abs != xdiff.abs
			return false
		end

		xstep = (if xdiff > 0 then 1 else -1 end)
		ystep = (if ydiff > 0 then 1 else -1 end)

		i = xstep
		j = ystep
		distance = xdiff
		while i.abs < distance.abs do
			if board[x1+i][y1+j] != ''
				return false
			end
			i += xstep
			j += ystep
		end
		return true
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