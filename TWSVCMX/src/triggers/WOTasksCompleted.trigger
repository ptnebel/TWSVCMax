trigger WOTasksCompleted on Work_Order_Task__c (after insert, after update) {
	WorkOrderTasks.TaskCompleted(Trigger.new); 
}