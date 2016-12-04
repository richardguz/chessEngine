class Rook
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

end