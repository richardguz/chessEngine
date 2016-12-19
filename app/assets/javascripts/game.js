function pollForGameUpdates(gid){
	$.get("/games/" + gid + "/state", function(game){
		//successfully got updates
		var board = game['board'];
		var turn = game['turn'];
		for (i = 0; i < 8; i++){ 
			for (j = 0; j < 8; j++){
    		var id = i.toString() + j.toString();
    		if (board[i][j] === board[i][j].toUpperCase()){
    			$('#' + id).css({ 'color': 'blue'});
    		}else{
    			$('#' + id).css({ 'color': 'red'});
    		}
    		$('#' + id).text(board[i][j]);
    	}
		}
		if (turn){
			$('#show_turn').text("White's Turn");
		}
		else{
			$('#show_turn').text("Black's Turn");
		}
	});
}