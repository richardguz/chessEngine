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
				:board => board
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
					game.player1_turn = !game.player1_turn
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
		#todo
		return true
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
end