function pollForGameUpdates(gid){
	$.get("/games/" + gid + "/state", function(game){
		//successfully got updates
		var board = game['board'];
		var turn = game['turn'];
		var pieces_captured = game['pieces_captured'];
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

		//update the pieces captured div
		$('#captured_pieces_white').text('');
		$('#captured_pieces_black').text('');
		$('#captured_pieces_white').css({ 'color': 'blue'});
		$('#captured_pieces_black').css({ 'color': 'red'});
		var captured_pieces_white = "";
		var captured_pieces_black = "";
		for (i = 0; i < pieces_captured.length; i++){
			if(pieces_captured[i] === pieces_captured[i].toUpperCase()){
				captured_pieces_white += " " + pieces_captured[i];
			}else{
				captured_pieces_black += " " + pieces_captured[i];;
			}
		}
		$('#captured_pieces_white').text(captured_pieces_white);
		$('#captured_pieces_black').text(captured_pieces_black);
		
		if (turn){
			$('#show_turn').text("White's Turn");
		}
		else{
			$('#show_turn').text("Black's Turn");
		}
	});
}