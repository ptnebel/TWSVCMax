public class SVMX_Next_PM_WorkOrder {
	public static void NextOrder(SVMXC__Service_Order__c[] orders){
		System.debug('Triggered Next Order');
		Map<id, SVMXC__Service_Order__c> orderMap = new Map<id,SVMXC__Service_Order__c>();
		for(SVMXC__Service_Order__c i: orders){
			orderMap.put(i.id, i);
		} 
		Integer TriggerCount=-1; Date TodayDate= date.today();
		List<SVMXC__Service_Order__c> orderList = new List<SVMXC__Service_Order__c>();
		List<SVMXC__Service_Contract__c> contractList = new List<SVMXC__Service_Contract__c>();
		 
		for(SVMXC__Service_Order__c ord: [select id, SVMXC__Company__r.Id, SVMXC__Order_Status__c, RecordType.Name, SVMXC__Component__r.Id, SVMXC__Component__r.Maintenance_Schedule__c from SVMXC__Service_Order__c where Id in: orderMap.keySet()]){
			TriggerCount++;
			// Create another work order if previous Closed and Preventive Maintenance
			if(ord.SVMXC__Order_Status__c=='Closed' && ord.RecordType.Name=='Preventive Maintenance' ){ 
				SVMXC__Service_Contract_Products__c[] contractProd = [select id, SVMXC__Service_Contract__r.Id ,SVMXC__Service_Contract__r.Maintenance_Schedule__c from SVMXC__Service_Contract_Products__c where SVMXC__Installed_Product__c=:ord.SVMXC__Component__r.Id];
				SVMXC__Service_Order__c[] otherOrders = [select id from SVMXC__Service_Order__c where SVMXC__Component__c=:ord.SVMXC__Component__r.Id AND RecordType.Name='Preventive Maintenance' AND SVMXC__Order_Status__c='Open'];
				if(otherOrders.size()==0){
					System.debug('ord: '+ord.SVMXC__Order_Status__c+' '+ord.RecordType.Name+' '+otherOrders.size());
					
					// Check each service contract for Maintenance Schedule
					SVMXC__Service_Order__c nso= orders[TriggerCount].clone(false, true);
					nso.SVMXC__Order_Status__c='Open';	
					// Installed Product Maintenance Schedule
					if(ord.SVMXC__Component__r.Maintenance_Schedule__c=='Monthly'){
						nso.Scheduled_Maintenance__c = TodayDate.addMonths(1); 
						orderList.add(nso);
					}
					else if(ord.SVMXC__Component__r.Maintenance_Schedule__c=='Bi-Monthly'){
						nso.Scheduled_Maintenance__c = TodayDate.addMonths(2); 
						orderList.add(nso);
					}
					else if(ord.SVMXC__Component__r.Maintenance_Schedule__c=='Quarterly'){
						nso.Scheduled_Maintenance__c = TodayDate.addMonths(3); 
						orderList.add(nso);
					}
					else if(ord.SVMXC__Component__r.Maintenance_Schedule__c=='Every 4th Month'){
						nso.Scheduled_Maintenance__c = TodayDate.addMonths(4); 
						orderList.add(nso);
					}
					else if(ord.SVMXC__Component__r.Maintenance_Schedule__c=='Semi-Annually'){
						nso.Scheduled_Maintenance__c = TodayDate.addMonths(6); 
						orderList.add(nso);
					}	
					else if(ord.SVMXC__Component__r.Maintenance_Schedule__c=='Annually'){
						nso.Scheduled_Maintenance__c = TodayDate.addMonths(12); 
						orderList.add(nso);
					} else {
						for(SVMXC__Service_Contract_Products__c contract: contractProd){
							nso.SVMXC__Group_Member__c=null;
							nso.SVMXC__Service_Group__c=null;
																				
							// Service Contract Maintenance Schedule
							if(contract.SVMXC__Service_Contract__r.Maintenance_Schedule__c=='Monthly'){
								nso.Scheduled_Maintenance__c = TodayDate.addMonths(1); 
								orderList.add(nso);
							} else if(contract.SVMXC__Service_Contract__r.Maintenance_Schedule__c=='Bi-Monthly'){
								nso.Scheduled_Maintenance__c = TodayDate.addMonths(2); 
								orderList.add(nso);
							} else if(contract.SVMXC__Service_Contract__r.Maintenance_Schedule__c=='Quarterly'){
								nso.Scheduled_Maintenance__c = TodayDate.addMonths(3);
								orderList.add(nso);
							} else if(contract.SVMXC__Service_Contract__r.Maintenance_Schedule__c=='Every 4th Month'){
								nso.Scheduled_Maintenance__c = TodayDate.addMonths(4);
								orderList.add(nso);	
							} else if(contract.SVMXC__Service_Contract__r.Maintenance_Schedule__c=='Semi-Annually'){
								nso.Scheduled_Maintenance__c = TodayDate.addMonths(6);
								orderList.add(nso);
							} else if(contract.SVMXC__Service_Contract__r.Maintenance_Schedule__c=='Annually'){
								nso.Scheduled_Maintenance__c = TodayDate.addMonths(12);
								orderList.add(nso);
							}
						}
					}
				}
			}
		}
		System.debug('orderList size: '+orderList.size());
		if(orderList.size()>0) {insert orderList;}	
	}




}