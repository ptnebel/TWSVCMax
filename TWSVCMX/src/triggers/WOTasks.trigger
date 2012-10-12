trigger WOTasks on SVMXC__Service_Order__c (after insert, after update) {
	WorkOrderTasks.CreateTasks(Trigger.new);
}