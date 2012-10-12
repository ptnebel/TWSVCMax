public with sharing class SVMX_Next_PM_WorkOrder_UT {
	static Account ac; 
	static Contact ct;
	static SVMXC__Service_Order__c svo;
	static SVMXC__Installed_Product__c ip;
	static Case cs;
	static SVMXC__Service_Level__c sl;
	static SVMXC__Service_Contract__c svcontract;
	static SVMXC__Service_Contract_Products__c cprod;
	
	public static void setupTest(){
		ac = new Account(
                                        Name ='Account',
                                        ShippingStreet='ABC',
                                        ShippingCity='PQR ',
                                        ShippingState = 'XYZ',
                                        ShippingPostalCode='111',
                                        ShippingCountry='XYZ'
                                        ); 
        insert ac; 
        ct = new Contact(LastName='Last',AccountId =ac.Id); 
        insert ct;  
        //Create Installed Product
        ip = new SVMXC__Installed_Product__c (
        								SVMXC__Company__c = ac.Id , 
        								SVMXC__Contact__c = ct.Id ,
        								Name = 'abc'
        								);
        insert ip;
        //Create Case                
        cs = new Case(Status ='New', Priority = 'Medium', 
                                            Origin = 'Email', 
                                            SVMXC__Component__c = ip.id,
                                            CurrencyIsoCode = 'USD',                                          
                                            ContactId =ct.Id,
                                            AccountId=ac.Id
                                            ); 
        insert cs;   
								
        //Create Service Contract
        sl = [select id from SVMXC__Service_Level__c limit 1];
        svcontract = new SVMXC__Service_Contract__c(
        								Name='Contract1',
        								SVMXC__Company__c = ac.Id ,
        								SVMXC__Start_Date__c = System.today(),
        								SVMXC__End_Date__c = System.today()+10,
        								SVMXC__Contract_Price2__c =2000,
        								SVMXC__Service_Level__c = sl.id,
        								Maintenance_Schedule__c = 'Monthly'  // - Contract
        								);
        insert svcontract;								
        // Create Service Contract Product
        cprod = new SVMXC__Service_Contract_Products__c(
        								SVMXC__Installed_Product__c=ip.id,
        								SVMXC__Service_Contract__c=svcontract.id
        								);
        insert cprod;
        								
        //Create Work Order
        RecordType rt = [select id, name from RecordType where SObjectType='SVMXC__Service_Order__c' AND name='Preventive Maintenance'];
        svo = new SVMXC__Service_Order__c (
                                        SVMXC__Case__c = cs.Id ,
                                        SVMXC__Component__c = ip.id,
                                        SVMXC__Company__c = ac.Id , 
                                        SVMXC__Order_Status__c = 'Open',
                                        SVMXC__Priority__c ='Medium',
                                        SVMXC__Order_Type__c='Field Service'
                                        );
         if(rt!=null) {svo.RecordTypeId=rt.id;}                              
         insert svo;        
         svo.SVMXC__Order_Status__c = 'Closed'; update svo;  
	}
	
	static testMethod void Test1(){
    	 ac=null; ct=null; svo=null;ip=null; cs=null; sl=null; svcontract=null; cprod=null;
         setupTest();
         
         //Bi-Monthly Check - Contract
         svcontract.Maintenance_Schedule__c = 'Bi-Monthly'; update svcontract;
         SVMXC__Service_Order__c[] otherOrders1 = [select id from SVMXC__Service_Order__c where SVMXC__Component__c=:ip.Id AND RecordType.Name='Preventive Maintenance' AND SVMXC__Order_Status__c='Open'];
    	 for(SVMXC__Service_Order__c next:otherOrders1){
    	 	next.SVMXC__Order_Status__c='Closed'; update next;
    	 }
	}
	
	static testMethod void Test2(){
    	 ac=null; ct=null; svo=null;ip=null; cs=null; sl=null; svcontract=null; cprod=null;
         setupTest();       
         
         //Semi-Annually Check - Contract
         svcontract.Maintenance_Schedule__c = 'Semi-Annually'; update svcontract;
         SVMXC__Service_Order__c[] otherOrders1 = [select id from SVMXC__Service_Order__c where SVMXC__Component__c=:ip.Id AND RecordType.Name='Preventive Maintenance' AND SVMXC__Order_Status__c='Open'];
    	 for(SVMXC__Service_Order__c next:otherOrders1){
    	 	next.SVMXC__Order_Status__c='Closed'; update next;
    	 }

	}
			
	static testMethod void Test4(){ 
    	 ac=null; ct=null; svo=null;ip=null; cs=null; sl=null; svcontract=null; cprod=null;
         setupTest();       		

    	 //Every 4th Month Check - Installed Product
         ip.Maintenance_Schedule__c = 'Every 4th Month'; update ip;
         SVMXC__Service_Order__c[] otherOrders6 = [select id from SVMXC__Service_Order__c where SVMXC__Component__c=:ip.Id AND RecordType.Name='Preventive Maintenance' AND SVMXC__Order_Status__c='Open'];
    	 for(SVMXC__Service_Order__c next:otherOrders6){
    	 	next.SVMXC__Order_Status__c='Closed'; update next;
    	 }   
    }
    
	static testMethod void Test5(){ 
    	 ac=null; ct=null; svo=null;ip=null; cs=null; sl=null; svcontract=null; cprod=null;
         setupTest();     		

    	 //Bi-Monthly - Installed Product
         ip.Maintenance_Schedule__c = 'Bi-Monthly'; update ip;
         SVMXC__Service_Order__c[] otherOrders6 = [select id from SVMXC__Service_Order__c where SVMXC__Component__c=:ip.Id AND RecordType.Name='Preventive Maintenance' AND SVMXC__Order_Status__c='Open'];
    	 for(SVMXC__Service_Order__c next:otherOrders6){
    	 	next.SVMXC__Order_Status__c='Closed'; update next;
    	 }   
    }    

	static testMethod void Test6(){ 
    	 ac=null; ct=null; svo=null;ip=null; cs=null; sl=null; svcontract=null; cprod=null;
         setupTest();     		

    	 //Bi-Monthly - Installed Product
         ip.Maintenance_Schedule__c = 'Quarterly'; update ip;
         SVMXC__Service_Order__c[] otherOrders6 = [select id from SVMXC__Service_Order__c where SVMXC__Component__c=:ip.Id AND RecordType.Name='Preventive Maintenance' AND SVMXC__Order_Status__c='Open'];
    	 for(SVMXC__Service_Order__c next:otherOrders6){
    	 	next.SVMXC__Order_Status__c='Closed'; update next;
    	 }   
    } 
}