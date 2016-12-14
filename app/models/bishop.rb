class Bishop
	def self.attemptMove(to, from, board)
		if isValidMove?(to, from, board)
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

end