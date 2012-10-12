public with sharing class WorkDetails {
	public static void changes(SVMXC__Service_Order_Line__c[] lines){
		// List Updates
		List<SVMXC__Service_Order_Line__c> updateWOLines = new List<SVMXC__Service_Order_Line__c>();
		
		Set<Id> Idset = new Set<Id>();
		for (SVMXC__Service_Order_Line__c line: lines)
  			Idset.add(line.Id);  			
  		List<SVMXC__Service_Order_Line__c> WOLines = [select id, Name, SVMXC__Service_Order__c, SVMXC__Consumed_From_Location__c, SVMXC__Service_Order__r.SVMXC__Group_Member__c  from SVMXC__Service_Order_Line__c where id=:idset];	
		
		Set<Id> Idset2 = new Set<Id>();
		for (SVMXC__Service_Order_Line__c WOLine1: WOLines){
  			Idset2.add(WOLine1.SVMXC__Service_Order__r.SVMXC__Group_Member__c);
			System.debug('WOLine1.SVMXC__Service_Order__r.SVMXC__Group_Member__c: '+WOLine1.SVMXC__Service_Order__r.SVMXC__Group_Member__c);
		}
  		List<SVMXC__Service_Group_Members__c> Techs = [select id, name, SVMXC__Inventory_Location__c from SVMXC__Service_Group_Members__c where id=:Idset2];	 
	
		for(SVMXC__Service_Order_Line__c WOLine: WOLines){
			System.debug('WOLine.SVMXC__Consumed_From_Location__c: '+WOLine.SVMXC__Consumed_From_Location__c);
			for(SVMXC__Service_Group_Members__c tech: Techs){
				System.debug('tech.SVMXC__Inventory_Location__c: '+tech.SVMXC__Inventory_Location__c);
				if(WOLine.SVMXC__Service_Order__r.SVMXC__Group_Member__c == tech.id 
				&& WOLine.SVMXC__Consumed_From_Location__c!= tech.SVMXC__Inventory_Location__c){
					WOLine.SVMXC__Consumed_From_Location__c= tech.SVMXC__Inventory_Location__c;
					updateWOLines.add(WOLine);
				}
			}
		}
		if(updateWOLines.size()>0) update updateWOLines;
	}
}