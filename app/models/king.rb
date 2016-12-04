class King

	def self.isValidMove?(to, from, board, piece)
		x1 = from[0]
		x2 = to[0]
		y1 = from[1]
		y2 = to[1]

		xdiff = (x2 - x1).abs
		ydiff = (y2 - y1).abs

		#checks if it's within the scope of king's movements
		if ((xdiff + ydiff > 2) || (xdiff > 1) || (ydiff > 1))
			return false
		end

		if self.isCheck?(to, board, piece)
			return false
		end

		return true
	end

	def self.isCheck?(coords, board, kingChar)
		#check if move puts king in check
		board.each_with_index do |row, i|
			row.each_with_index do |piece, j|
				if !(i == coords[0] && j == coords[1])
					puts "checking:"
					puts i
					puts j
					case piece
						when (if kingChar == 'K' then 'n' else 'N' end)
							if Knight.isValidMove?(coords, [i, j], board)
								return true
							end
						when (if kingChar == 'K' then 'r' else 'R' end)
							if Rook.isValidMove?(coords, [i, j], board)
								return true
							end
						when (if kingChar == 'K' then 'k' else 'K' end)
							if King.isValidMove?( coords, [i, j], board, (if kingChar == 'K' then 'k' else 'K' end))
								return true
							end
						when (if kingChar == 'K' then 'b' else 'B' end)
							if Bishop.isValidMove?( coords, [i, j], board)
								return true
							end
						when (if kingChar == 'K' then 'q' else 'Q' end)
							puts "checking queen"
							if Queen.isValidMove?( coords, [i, j], board)
								return true
							end
						when (if kingChar == 'K' then 'p' else 'P' end)
							if Pawn.isValidTake?(coords, [i, j], board, (if kingChar == 'K' then 'p' else 'P' end), true)
								return true
							end
						else puts "do nothing"
					end
				end
			end
		end
		return false
	end

end