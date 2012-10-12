trigger updateConsumedFromLocation on SVMXC__Service_Order_Line__c (after insert, after update) {
	WorkDetails.changes(Trigger.new);
}