trigger WorkOrderUpdate on SVMXC__Service_Order__c (after insert, after update) {
	if(Trigger.new.size()>0 && Trigger.new.size()<100){  // watch for batch size
		WorkOrder.updateCountry(Trigger.new);  
	}
}