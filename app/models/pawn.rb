class Pawn
	def self.isValidMove?(to, from, board, piece)
		x1 = from[0]
		x2 = to[0]
		y1 = from[1]
		y2 = to[1]

		xdiff = x2 - x1
		ydiff = y2 - y1

		#check if it's a valid take
		if isValidTake?(to, from, board, piece, false)
			return true
		end

		#check if any horizontal movement
		if ydiff != 0
			return false
		end

		#check for 1 forward, or 2 if in start row
		dir = (if piece == 'P' then -1 else 1 end)
		startRow = (if piece == 'P' then 6 else 1 end)
		inStartRow = (startRow == x1)
		if xdiff == dir && board[x2][y2] == ''
			return true
		elsif xdiff == 2*dir && board[x1+dir][y1] == '' && board[x2][y2] == '' && inStartRow
			return true
		end

		return false
	end

	def self.isValidTake?(to, from, board, piece, hypothetical)
		puts "CHECKING PAWN"
		x1 = from[0]
		x2 = to[0]
		y1 = from[1]
		y2 = to[1]

		xdiff = x2 - x1
		ydiff = (y2 - y1).abs
		#check if there is a piece in the to
		if board[x2][y2] == '' && !hypothetical
			puts "#1"
			return false
		end


		#check that it is in the correct direction up one and over one
		if piece == 'P'
			xdiff *= -1
		end

		if xdiff != 1
			puts "#2"
			return false
		elsif ydiff != 1
			puts "#3"
			return false
		end

		return true
	end
end