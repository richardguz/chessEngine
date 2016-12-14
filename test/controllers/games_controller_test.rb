require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
	def setup
		board = [['r', 'n', 'b', 'k', 'q', 'b', 'n', 'r'],
						 ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
						 ['' ,  '',  '',  '',  '', '' , '' , '' ],
						 ['' ,  '',  '',  '',  '', '' , '' , '' ],
						 ['' ,  '',  '',  '',  '', '' , '' , '' ],
						 ['' ,  '',  '',  '',  '', '' , '' , '' ],
						 ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
						 ['R', 'N', 'B', 'K', 'Q', 'B', 'N', 'R']]
		@player1_token = "a"
		@player2_token = "b"
		@game = Game.create(:player1_token => @player1_token, :en_passant => {:x => -1, :y => -1}.to_json, :player2_token => @player2_token, :board => {:board => board}.to_json, :player1_turn => true)
	end

	def postMove(token, from, to, valid)
		headers = { 'CONTENT_TYPE' => 'application/json' }
		params = { token: token, from: from, to: to}
		post "/games/" + @game.id.to_s + "/move", as: :json, headers: headers, params: params
		assert_response :success
		if valid
		  assert_equal "", response.body
		else
    	assert_equal JSON.parse(response.body), {"error" => "Move is invalid"}
		end
	end
  
  test "pawn movement" do
  	#white king pawn 2 spaces
  	postMove(@player1_token, [6,3], [4,3], true)

    #black king pawn 2 spaces
    postMove(@player2_token, [1,3], [3,3], true)

    #white queen pawn 1 space
    postMove(@player1_token, [6,4], [5,4], true)

    #black queen pawn 1 spaces
    postMove(@player2_token, [1,4], [2,4], true)

    #white queen pawn 2 more spaces try
    postMove(@player1_token, [5,4], [3,4], false)

    #white queen pawn 1 more space
    postMove(@player1_token, [5,4], [4,4], true)

    #black pawn take pawn
    postMove(@player2_token, [3,3], [4,4], true)

  end

  test "rook movement" do
  	#white left rook pawn up 2
  	postMove(@player1_token, [6,0], [4,0], true)

    #black left rook pawn up 2
  	postMove(@player2_token, [1,0], [3,0], true)

    #white queen pawn up 1
  	postMove(@player1_token, [6,4], [5,4], true)

    #black rook up 4 try
  	postMove(@player2_token, [0,0], [4,0], false)
  
    #black left rook up 2
  	postMove(@player2_token, [0,0], [2,0], true)

    #white rook up 2
  	postMove(@player1_token, [7,0], [5,0], true)

    #black left rook right 5
  	postMove(@player2_token, [2,0], [2,5], true)
  end

  test "knight movement" do
  	#white knight up 2 right 1
  	postMove(@player1_token, [7,1], [5,2], true)

    #black knight up 2 left 1
    postMove(@player2_token, [0,1], [2,0], true)

    #white knight up 1 left 2
    postMove(@player1_token, [5,2], [4,0], true)

    #black knight try up 2 right 2
    postMove(@player2_token, [2,0], [4,2], false)
  end

  test "bishop movement" do
  	#white king pawn up 2
  	postMove(@player1_token, [6,3], [4,3], true)

  	#black queen pawn up 2
    postMove(@player2_token, [1,4], [3,4], true)

    #white black bishop up 2 right 2
  	postMove(@player1_token, [7,2], [5,4], true)

  	#black black bishop up 3 left 3
    postMove(@player2_token, [0,5], [3,2], true)

    #white black bishop take black black bishop try
  	postMove(@player1_token, [5,4], [3,2], false)

  	#white king pawn up 1
  	postMove(@player1_token, [4,3], [3,3], true)

  	#black black bishop takes white black bishop
    postMove(@player2_token, [3,2], [5,4], true)
  end

  test "king movement" do
  	#white king pawn up 2
  	postMove(@player1_token, [6,3], [4,3], true)

  	#black king pawn up 2
  	postMove(@player2_token, [1,3], [3,3], true)

  	#white king up 1
  	postMove(@player1_token, [7,3], [6,3], true)

  	#black king up 1
  	postMove(@player2_token, [0,3], [1,3], true)

  	#white king up 1 more 
  	postMove(@player1_token, [6,3], [5,3], true)
 
  	#black king up 1 more
  	postMove(@player2_token, [1,3], [2,3], true)

  	#white king down 1 
  	postMove(@player1_token, [5,3], [6,3], true)

  	#black queen to check test position
  	postMove(@player2_token, [0,4], [3,1], true)

  	#white king up 1 try (but would be check)
  	postMove(@player1_token, [6,3], [5,3], false)
  end

  test "queen movement" do
  	#white queen pawn up 2
  	postMove(@player1_token, [6,4], [4,4], true)

  	#black king pawn up 2
  	postMove(@player2_token, [1,3], [3,3], true)

  	#white queen up 2
  	postMove(@player1_token, [7,4], [5,4], true)

  	#black queen up 3 left 3
  	postMove(@player2_token, [0,4], [3,1], true)

  	#white queen pawn up 1
  	postMove(@player1_token, [4,4], [3,4], true)

  	#black king pawn up 1
  	postMove(@player2_token, [3,3], [4,3], true)

  	#white rook pawn up 1
  	postMove(@player1_token, [6,0], [5,0], true)

  	#black queen right 5 try
  	postMove(@player2_token, [3,1], [3,6], false)

  	#black queen right 3, take white king pawn
  	postMove(@player2_token, [3,1], [3,4], true)
  end

  test "king side castle allowed" do
  	#white king pawn up 1
  	postMove(@player1_token, [6,3], [5,3], true)

  	#black king pawn up 1
  	postMove(@player2_token, [1,3], [3,3], true)

  	#white bishop out
  	postMove(@player1_token, [7,2], [5,4], true)

  	#black bishop out
  	postMove(@player2_token, [0,2], [2,4], true)

  	#white knight out
  	postMove(@player1_token, [7,1], [5,2], true)

  	#black knight out
  	postMove(@player2_token, [0,1], [2,2], true)

  	#white king side castle
  	postMove(@player1_token, [7,3], [7,1], true)

  	#black king side castle
  	postMove(@player2_token, [0,3], [0,1], true)
  end

  test "king side castle not allowed" do
  	#white king pawn up 1
  	postMove(@player1_token, [6,3], [5,3], true)

  	#black king pawn up 1
  	postMove(@player2_token, [1,3], [3,3], true)

  	#white bishop out
  	postMove(@player1_token, [7,2], [5,4], true)

  	#black bishop out
  	postMove(@player2_token, [0,2], [2,4], true)

  	#white knight out
  	postMove(@player1_token, [7,1], [5,2], true)

  	#black knight out
  	postMove(@player2_token, [0,1], [2,2], true)

    #white king moves left 1
    postMove(@player1_token, [7,3], [7,2], true)

    #black king moves left 1
    postMove(@player2_token, [0,3], [0,2], true)

    #white king moves right 1
    postMove(@player1_token, [7,2], [7,3], true)

    #black king moves right 1
    postMove(@player2_token, [0,2], [0,3], true)

  	#white king side castle
  	postMove(@player1_token, [7,3], [7,1], false)

    #white king move 1 left (not significant)
    postMove(@player1_token, [7,3], [7,2], true)

  	#black king side castle
  	postMove(@player2_token, [0,3], [0,1], false)
  end

  test "queen side castle allowed" do
    #white king pawn up 2
    postMove(@player1_token, [6,3], [4,3], true)

    #black king pawn up 2
    postMove(@player2_token, [1,3], [3,3], true)

    #white queen pawn up 1
    postMove(@player1_token, [6,4], [5,4], true)

    #black queen pawn up 1
    postMove(@player2_token, [1,4], [2,4], true)

    #white queen out
    postMove(@player1_token, [7,4], [3,0], true)

    #black queen out
    postMove(@player2_token, [0,4], [4,0], true)

    #white knight out
    postMove(@player1_token, [7,6], [5,7], true)

    #black knight out
    postMove(@player2_token, [0,6], [2,7], true)

    #white bishop out
    postMove(@player1_token, [7,5], [4,2], true)

    #black bishop out
    postMove(@player2_token, [0,5], [3,2], true)

    #white queen side castle
    postMove(@player1_token, [7,3], [7,5], true)

    #black queen side castle
    postMove(@player2_token, [0,3], [0,5], true)
  end

  test "queen side castle not allowed" do
    #white king pawn up 2
    postMove(@player1_token, [6,3], [4,3], true)

    #black king pawn up 2
    postMove(@player2_token, [1,3], [3,3], true)

    #white queen pawn up 1
    postMove(@player1_token, [6,4], [5,4], true)

    #black queen pawn up 1
    postMove(@player2_token, [1,4], [2,4], true)

    #white queen out
    postMove(@player1_token, [7,4], [3,0], true)

    #black queen out
    postMove(@player2_token, [0,4], [4,0], true)

    #white knight out
    postMove(@player1_token, [7,6], [5,7], true)

    #black knight out
    postMove(@player2_token, [0,6], [2,7], true)

    #white bishop out
    postMove(@player1_token, [7,5], [4,2], true)

    #black bishop out
    postMove(@player2_token, [0,5], [3,2], true)

    #white rook left
    postMove(@player1_token, [7,7], [7,6], true)

    #black rook left
    postMove(@player2_token, [0,7], [0,5], true)

    #white rook right
    postMove(@player1_token, [7,6], [7,7], true)

    #black rook right (but not all the way (out of position for castle))
    postMove(@player2_token, [0,5], [0,6], true)

    #white queen side castle
    postMove(@player1_token, [7,3], [7,5], false)

    #white king move to allow black to go
    postMove(@player1_token, [7,3], [7,4], true)

    #black queen side castle
    postMove(@player2_token, [0,3], [0,5], false)
  end

    test "en passant allowed" do
    #white king pawn 2 spaces
    postMove(@player1_token, [6,3], [4,3], true)

    #black rook pawn 2 spaces
    postMove(@player2_token, [1,0], [3,0], true)

    #white king pawn 1 space
    postMove(@player1_token, [4,3], [3,3], true)

    #black queen pawn 2 spaces
    postMove(@player2_token, [1,4], [3,4], true)

    #white king pawn take black queen pawn with en passant
    postMove(@player1_token, [3,3], [2,4], true)
  end

  test "en passant not allowed" do
    #white king pawn 2 spaces
    postMove(@player1_token, [6,3], [4,3], true)

    #black rook pawn 2 spaces
    postMove(@player2_token, [1,0], [3,0], true)

    #white king pawn 1 space
    postMove(@player1_token, [4,3], [3,3], true)

    #black queen pawn 2 spaces
    postMove(@player2_token, [1,4], [3,4], true)

    #white king forward 1 space
    postMove(@player1_token, [7,3], [6,3], true)

    #black rook pawn 1 more space
    postMove(@player2_token, [3,0], [4,0], true)

    #white king pawn take black queen pawn with en passant attempt
    postMove(@player1_token, [3,3], [2,2], false)
  end

end
