public with sharing class WorkOrder {
	public static void updateCountry(List<SVMXC__Service_Order__c> orders){
		List<SVMXC__Service_Order__c> orderupdates = new List<SVMXC__Service_Order__c>();
		for(SVMXC__Service_Order__c order: orders){
			if(order.Country_Text__c!=null && order.SVMXC__Country__c==null){
				SVMXC__Service_Order__c o = new SVMXC__Service_Order__c(id=order.id);
				o.SVMXC__Country__c = order.Country_Text__c;
				orderupdates.add(o);
			}			
		}
		if(orderupdates.size()>0) update orderupdates;
	} 
	
	public static testmethod void tWorkOrder(){
		SVMXC__Service_Order__c svo = new SVMXC__Service_Order__c();
		svo.Country_Text__c ='United States'; svo.SVMXC__Country__c=null;
		insert svo;
		List<SVMXC__Service_Order__c> svos = new List<SVMXC__Service_Order__c>();
		svos.add(svo);
		updateCountry(svos);
	}
}