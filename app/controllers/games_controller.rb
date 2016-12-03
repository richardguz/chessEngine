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
			@board['board'] = @board['board'].reverse
		else
			render :json => {:error => "Could not find game"}
		end
	end

	def state
		if Game.exists?(params[:id])
			game = Game.find(params[:id])
			board = JSON.parse(game.board)
			board['board'] = board['board'].reverse
			data = {
				:turn => !game.player1_turn,
				:board => board
			}
			render :json => data
		else
			render :json => {:error => "Could not find game"}
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
			[['R', 'N', 'B', 'K', 'Q', 'B', 'N', 'R'], 
			 ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
			 ['', '', '', '', '', '', '', ''],
			 ['', '', '', '', '', '', '', ''],
			 ['', '', '', '', '', '', '', ''],
			 ['', '', '', '', '', '', '', ''],
			 ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
			 ['r', 'n', 'b', 'k', 'q', 'b', 'n', 'r']]
	end
end
