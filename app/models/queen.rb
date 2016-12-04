class Queen
	def self.isValidMove?(to, from, board)
		return Bishop.isValidMove?(to, from, board) || Rook.isValidMove?(to, from, board)
	end
end