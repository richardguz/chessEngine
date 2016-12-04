class GamesController < ApplicationController
	require 'json'

	def new
		#generate player tokens
		player1_token = generatePlayerToken

		#generate board
		board = newBoard

		#save new game to DB
		if game = Game.create(:player1_token => player1_token, :board => {:board => board}.to_json, :player1_turn => true) 
			#assemble data and send to requesting client in response body (if creation successful)
			#turn true is your turn, turn false is opponent's turn
			data = {
				:token => player1_token,
				:turn => true,
				:board => board
			}
			puts game.board
			render :json => data
		else
			render :json => {:error => "Could not create game"}
		end
	end

	def join
		#check if game exists
		#TODO: check if there are already 2 users, reject
		#TODO: make it just 1 DB lookup
		if Game.exists?(params[:id])
			g = Game.find(params[:id])
			player2_token = generatePlayerToken
			player1_token = g.player1_token
			#make sure two tokens are not the same
			while player1_token == player2_token do
				player2_token = generatePlayerToken
			end
			
			#save player2_token 
			g.player2_token = player2_token
			g.save
			
			#respond with token and board layout
			data = {
				:token => player2_token,
				:turn => !g.player1_turn,
				:board => g.board
			}
			render :json => data
		else
			#failed to find game, send json response with error
			render :json => {:error => "Could not find game"}
		end
	end

	def show
		if Game.exists?(params[:id])
			@game = Game.find(params[:id])
			@board = JSON.parse(@game.board)
		else
			render :json => {:error => "Could not find game"}
		end
	end

	#returns game state (not for players, but for polling to display board)
	def state
		if Game.exists?(params[:id])
			game = Game.find(params[:id])
			board = JSON.parse(game.board)
			data = {
				:turn => game.player1_turn,
				:board => board['board']
			}
			render :json => data
		else
			render :json => {:error => "Could not find game"}
		end
	end

	def move
		#check if the game exists
		if Game.exists?(params[:id])
			game = Game.find(params[:id])
			data = request.raw_post
			data_parsed = JSON.parse(data)
			player_token = data_parsed['token']
			from = data_parsed['from']
			to = data_parsed['to']
			#check token and see if it's that player's turn
			if isPlayerTurn?(player_token, game)
				#check if the move is valid
				if isMoveValid?(game, from, to)
					#change the state of the board accordingly (and change the turn variable)
					old_board = JSON.parse(game.board)['board']
					old_board[to[0]][to[1]] = old_board[from[0]][from[1]]
					old_board[from[0]][from[1]] = ''
					game.board = {:board => old_board}.to_json
					#todo uncomment
					#game.player1_turn = !game.player1_turn
					game.save
				else
					#return move invalid error
					render :json => {:error => "Move is invalid"}
				end
			else
				#return not player's turn error
				render :json => {:error => "Wait your turn"}
			end
		else
			#return game does not exist error
			render :json => {:error => "Game does not exist"}
		end
	end

	def isPlayerTurn?(player_token, game)
		turn = game.player1_turn
		if turn
			#if player 1's turn
			player1_token = game.player1_token
			if player_token == player1_token
				return true
			else
				#not the player's turn
				return false
			end	
		else
			#if player 2's turn
			player2_token = game.player2_token
			if player_token == player2_token
				return true
			else
				#not the player's turn
				return false
			end
		end
	end

	def isMoveValid?(game, from, to)
		old_board = JSON.parse(game.board)['board']
		#check if the coords are on the board
		if !isOnBoard?(to, from)
			return false
		end
		#check if to == from (no move was made)
		if to == from
			return false
		end
		piece_moved = old_board[from[0]][from[1]]
		target_cell = old_board[to[0]][to[1]]
		#check if from piece moved is valid
		if !isValidPiece?(piece_moved, game)
			return false
		end
		#check if target is either empty or of opposite color
		if !isValidTarget?(piece_moved, to, old_board)
			return false
		end
		if !isMoveValidForPiece?(piece_moved, from, to, old_board)
			return false
		end
		return true
	end 

	def isMoveValidForPiece?(piece, from, to, old_board)
		case piece
			when 'N', 'n'
				return Knight.isValidMove?(to, from, old_board)
			when 'R', 'r'
				return Rook.isValidMove?(to, from, old_board)
			else return true
		end

	end

	def isValidTarget?(piece, to, board)
		if board[to[0]][to[1]] == ''
			return true
		elsif isWhite?(board[to[0]][to[1]]) == !isWhite?(piece)
			return true
		else
			return false
		end
	end

	def isValidPiece?(piece, game)
		#if no piece on from cell
		if piece == ''
			return false
		elsif !isWhite?(piece) && game.player1_turn
			return false
		elsif isWhite?(piece) && !game.player1_turn
			return false
		end
		return true
	end

	def isOnBoard?(to, from)
		allCoords = to + from
		minCoord = allCoords.min
		maxCoord = allCoords.max
		if minCoord < 0 || maxCoord > 7
			return false
		else
			return true
		end
	end

	private
	#generates a random player token (50 chars just letters caps and lowercase)
	def generatePlayerToken
		o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
		string = (0...50).map { o[rand(o.length)] }.join
		return string
	end

	#returns a new board (array) with all pieces in starting positions
	def newBoard
			[['r', 'n', 'b', 'k', 'q', 'b', 'n', 'r'],
			 ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
			 ['', '', '', '', '', '', '', ''],
			 ['', '', '', '', '', '', '', ''],
			 ['', '', '', '', '', '', '', ''],
			 ['', '', '', '', '', '', '', ''],
			 ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
			 ['R', 'N', 'B', 'K', 'Q', 'B', 'N', 'R']]
	end

	#returns true if color is white, false if color is black
	def isWhite?(piece)
		if upcase?(piece)
			return true
		else
			return false
		end
	end

	def upcase?(c)
		/[[:upper:]]/.match(c)
	end
end