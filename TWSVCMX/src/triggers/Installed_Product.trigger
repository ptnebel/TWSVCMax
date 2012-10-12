trigger Installed_Product on SVMXC__Installed_Product__c (after insert) {

	for (SVMXC__Installed_Product__c ip: trigger.new){
		TW_WS_Services.createThinginTw_future(ip.id);
	}

}