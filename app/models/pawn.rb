class Pawn
	include PieceModule
	def self.attemptMove(to, from, game)		
		board = JSON.parse(game.board)['board']
		en_passant = JSON.parse(game.en_passant)
		piece = board[from[0]][from[1]]
		if isValidMove?(to, from, board, piece)

			cell_attacked = board[to[0]][to[1]]
			if cell_attacked != ''
				take_piece(cell_attacked, game)
			end
			board[to[0]][to[1]] = board[from[0]][from[1]]

			if to[0] == 7
				board[to[0]][to[1]] = 'q'
			elsif to[0] == 0
				board[to[0]][to[1]] = 'Q'
			end
			board[from[0]][from[1]] = ''
			if (to[0] - from[0]).abs == 2
				en_passant['x'] = from[0] + (if game.player1_turn then -1 else 1 end)
				en_passant['y'] = from[1]
				game.en_passant = en_passant.to_json
			else
				en_passant['x'] = -1
				en_passant['y'] = -1
				game.en_passant = en_passant.to_json
			end
		elsif isValidEnPassant?(to, from, game)
			return performEnPassant(from, game)
		end
		return board
	end

	def self.isValidEnPassant?(to, from, game)
		en_passant = JSON.parse(game.en_passant)
		board = JSON.parse(game.board)['board']
		if en_passant['x'] == to[0] && en_passant['y'] == to[1]
			if isValidTake?(to, from, board, 'P', true) && game.player1_turn
				return true
			elsif isValidTake?(to, from, board, 'p', true) && !game.player1_turn
				return true
			end
		end
		return false
	end

	def self.performEnPassant(from, game)
		board = JSON.parse(game.board)['board']
		en_passant = JSON.parse(game.en_passant)
		board[from[0]][from[1]] = ''
		if game.player1_turn
			board[en_passant['x']][en_passant['y']] = 'P'
			board[en_passant['x'] + 1][en_passant['y']] = '' 
		else
			board[en_passant['x']][en_passant['y']] = 'p'
			board[en_passant['x'] - 1][en_passant['y']] = '' 
		end
		en_passant['x'] = -1
		en_passant['y'] = -1
		game.en_passant = en_passant.to_json
		return board
	end

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
		x1 = from[0]
		x2 = to[0]
		y1 = from[1]
		y2 = to[1]

		xdiff = x2 - x1
		ydiff = (y2 - y1).abs
		#check if there is a piece in the to
		if board[x2][y2] == '' && !hypothetical
			return false
		end


		#check that it is in the correct direction up one and over one
		if piece == 'P'
			xdiff *= -1
		end

		if xdiff != 1
			return false
		elsif ydiff != 1
			return false
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