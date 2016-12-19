class King
	def self.attemptMove(to, from, game)
		board = JSON.parse(game.board)['board']
		piece = board[from[0]][from[1]]
		if isValidMove?(to, from, board, piece)
			cell_attacked = board[to[0]][to[1]]
			if cell_attacked != ''
				take_piece(cell_attacked, game)
			end
			board[to[0]][to[1]] = board[from[0]][from[1]]
			board[from[0]][from[1]] = ''
			if game.player1_turn
				game.white_can_castle_king_side = false
				game.white_can_castle_queen_side = false
			else
				game.black_can_castle_king_side = false
				game.black_can_castle_queen_side = false
			end
		elsif isValidKingSideCastle?(to, from, game)
			return performKingSideCastle(game)
		elsif isValidQueenSideCastle?(to, from, game)
			return performQueenSideCastle(game)
		end
		return board
	end

	def self.isValidKingSideCastle?(to, from, game)
		board = JSON.parse(game.board)['board']
		if game.player1_turn
			#white castle attempt
			if to[0] == 7 && to[1] == 1 && from[0] == 7 && from[1] == 3 && board[7][3] == 'K'
				#if valid to/from and king is in right place
				if game.white_can_castle_king_side
					#still able to castle king side
					if board[7][1] == '' && board[7][2] == ''
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end 
		else
			#black castle attempt
			if to[0] == 0 && to[1] == 1 && from[0] == 0 && from[1] == 3 && board[0][3] == 'k'
				#if valid to/from and king is in right place
				if game.black_can_castle_king_side
					#still able to castle king side
					if board[0][1] == '' && board[0][2] == ''
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		end
		return false
	end

	def self.isValidQueenSideCastle?(to, from, game)
		board = JSON.parse(game.board)['board']
		if game.player1_turn
			#white castle attempt
			if to[0] == 7 && to[1] == 5 && from[0] == 7 && from[1] == 3 && board[7][3] == 'K'
				#if valid to/from and king is in right place
				if game.white_can_castle_queen_side
					#still able to castle king side
					if board[7][4] == '' && board[7][5] == '' && board[7][6] == ''
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end 
		else
			#black castle attempt
			if to[0] == 0 && to[1] == 5 && from[0] == 0 && from[1] == 3 && board[0][3] == 'k'
				#if valid to/from and king is in right place
				if game.black_can_castle_queen_side
					#still able to castle king side
					if board[0][4] == '' && board[0][5] == '' && board[0][6] == ''
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		end
		return false
	end

	def self.performKingSideCastle(game)
		board = JSON.parse(game.board)['board']
		if game.player1_turn
			#white king side castle
			board[7][3] = ''
			board[7][2] = 'R'
			board[7][1] = 'K'
			board[7][0] = ''
			game.white_can_castle_king_side = false
			game.white_can_castle_queen_side = false
		else
			#perform black king side castle
			board[0][3] = ''
			board[0][2] = 'r'
			board[0][1] = 'k'
			board[0][0] = ''
			game.black_can_castle_king_side = false
			game.black_can_castle_queen_side = false
		end
		return board
	end

	def self.performQueenSideCastle(game)
		board = JSON.parse(game.board)['board']
		if game.player1_turn
			#perform white queen side castle
			board[7][3] = ''
			board[7][4] = 'R'
			board[7][5] = 'K'
			board[7][7] = ''
			game.white_can_castle_king_side = false
			game.white_can_castle_queen_side = false
		else
			#perform black queen side castle
			board[0][3] = ''
			board[0][4] = 'r'
			board[0][5] = 'k'
			board[0][7] = ''
			game.black_can_castle_king_side = false
			game.black_can_castle_queen_side = false
		end
		return board
	end

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
							if Queen.isValidMove?( coords, [i, j], board)
								return true
							end
						when (if kingChar == 'K' then 'p' else 'P' end)
							if Pawn.isValidTake?(coords, [i, j], board, (if kingChar == 'K' then 'p' else 'P' end), true)
								return true
							end
					end
				end
			end
		end
		return false
	end

	def self.isInCheck?(board, kingChar)
		if kingChar == 'K' || kingChar == 'k'
			coords = findPiece(board, kingChar)
			return isCheck?(coords, board, kingChar)
		else
			return false
		end
	end

	def self.findPiece(board, piece)
		8.times do |i|
			8.times do |j|
				if board[i][j] == piece
					return [i,j]
				end
			end
		end
		return [-1,-1]
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