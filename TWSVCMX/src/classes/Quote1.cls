public with sharing class Quote1 {
    public Quote1(){}
    private final Quote quote;  
    public Quote qt; public Quote getquote(){ return qt;}
    List<QuoteLineItem> quotelines; public List<QuoteLineItem> getquotelines(){ return quotelines; }
    private final ApexPages.StandardController theController;
    public Quote1(ApexPages.StandardController stdController){
        quote = (Quote)stdController.getRecord();
        theController = stdController;
    } 
    public SVMXC__Service_Order__c wo = new SVMXC__Service_Order__c();
    public SVMXC__Service_Order__c getwo() {
        return wo;            
    } 
    SVMXC__Service_Order__c ord = new SVMXC__Service_Order__c();
    List<SVMXC__Service_Order_Line__c> details = new List<SVMXC__Service_Order_Line__c>();        
	String quoteId = System.currentPageReference().getParameters().get('id');
	String quoteName = System.currentPageReference().getParameters().get('name');	
	public String getQuoteName(){ 
		return quoteName; 
	}    
    public void AttachToWorkOrder(){                      
        qt = [Select Id, Name, Opportunity.Name, Opportunity.AccountId, Status, GrandTotal, ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, (select id, UnitPrice,TotalPrice, Quantity, PricebookEntryId, PricebookEntry.Product2Id, ListPrice from QuoteLineItems) from Quote where id=:quoteId limit 1];
        quotelines = qt.QuoteLineItems;           
    }
    
    public PageReference Save(){
    	//WO Header
    	ord=wo;
    	ord.SVMXC__Company__c = qt.Opportunity.AccountId;
    	ord.SVMXC__Order_Status__c = 'Open';
    	ord.SVMXC__Street__c = qt.ShippingStreet;
    	ord.SVMXC__City__c = qt.ShippingCity;
    	ord.SVMXC__State__c = qt.ShippingState;
    	ord.SVMXC__Zip__c = qt.ShippingPostalCode;
		insert ord;
		//WO Details
		for(QuoteLineItem qline: quotelines){
			SVMXC__Service_Order_Line__c detail = new SVMXC__Service_Order_Line__c();
			RecordType rectype = [select id, name from RecordType where SobjectType='SVMXC__Service_Order_Line__c' AND Name='Estimate' limit 1];
			detail.SVMXC__Service_Order__c = ord.id;
			detail.RecordTypeId = rectype.id;
			detail.SVMXC__Line_Type__c ='Parts';
			detail.SVMXC__Product__c = qline.PricebookEntry.Product2Id;
			detail.SVMXC__Estimated_Quantity2__c = qline.Quantity;
			detail.SVMXC__Estimated_Price2__c = qline.UnitPrice; 
			details.add(detail);
		}
		insert details;
		PageReference page = new PageReference('/'+ord.Id);
		return page; 
	}
	
	public PageReference Cancel(){
		PageReference page = new PageReference('/'+quoteId);
		return page;
	}
    
}