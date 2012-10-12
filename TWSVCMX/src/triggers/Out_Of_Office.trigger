trigger Out_Of_Office on Out_of_Office__c (after insert) {
	Out_Of_Office.changes(Trigger.new);
}