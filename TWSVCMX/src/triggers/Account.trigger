trigger Account on Account (after insert) {

	for (Account a: trigger.new){
		TW_WS_Services.createCustomerinTw_future(a.id)	;
	}

}