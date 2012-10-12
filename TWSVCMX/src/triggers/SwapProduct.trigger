trigger SwapProduct on Product_Swap__c (after insert, after update) {
	SwapComponent.SwapNow(Trigger.new);
}