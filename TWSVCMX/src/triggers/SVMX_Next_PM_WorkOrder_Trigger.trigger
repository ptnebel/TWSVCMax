trigger SVMX_Next_PM_WorkOrder_Trigger on SVMXC__Service_Order__c (after insert, after update) {
    SVMX_Next_PM_WorkOrder.NextOrder(Trigger.new);
}