class Rook
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
			if game.player1_turn
				if from == [7,0]
					game.white_can_castle_king_side = false
				elsif from == [7,7]
					game.white_can_castle_queen_side = false
				end
			else
				if from == [0,0]
					game.black_can_castle_king_side = false
				elsif from == [0,7]
					game.black_can_castle_queen_side = false
				end			
			end
		end
		return board
	end

	def self.isValidMove?(to, from, board)
		if !isValidWithoutObstructions?(to, from)
			return false
		elsif anyObstructions?(to, from, board)
			return false
		else
			return true
		end
	end

	def self.isValidWithoutObstructions?(to, from)
		if from[0] == to[0] || from[1] == to[1]
			return true
		else
			return false
		end
	end

	def self.anyObstructions?(to, from, board)
		if to[0] - from[0] > 0
			#move vertically (+)
			i = 1
			distance = to[0] - from[0]
			while i < distance  do
				if board[from[0] + i][from[1]] != ''
					return true
				end
			  i += 1
			end
			return false
		elsif to[1] - from[1] > 0
			#move horizontally (+)
			i = 1
			distance = to[1] - from[1]
			while i < distance  do
				if board[from[0]][from[1] + i] != ''
					return true
				end
			  i += 1
			end
			return false
		elsif to[1] - from[1] < 0
			#move horizontally (-)
			i = -1
			distance = to[1] - from[1]
			while i > distance  do
				if board[from[0]][from[1] + i] != ''
					return true
				end
			  i -= 1
			end
			return false
		elsif to[0] - from[0] < 0
			#move vertically (-)
			i = -1
			distance = to[0] - from[0]
			while i > distance  do
				if board[from[0] + i][from[1]] != ''
					return true
				end
			  i -= 1
			end
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