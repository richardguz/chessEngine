function pollForGameUpdates(gid){
	$.get("/games/" + gid + "/state", function(game){
		//successfully got updates
		var board = game['board']['board']
		var turn = game['turn']
		for (i = 0; i < 8; i++){ 
			for (j = 0; j < 8; j++){
				console.log(i)
				console.log(j)
    		var id = i.toString() + j.toString();
    		console.log(id)
    		$('#' + id).text(board[i][j]);
    	}
		}
	});
}