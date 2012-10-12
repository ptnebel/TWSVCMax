public with sharing class ServiceMaxMassDataEdit {
	public String username {get;set;}
	public String pwd {get;set;}
	public void loginSite(){}
	List<SVMXC__Service_Order__c> wo = new List<SVMXC__Service_Order__c>();   // SVMXC__Service_Order__c
	public String button = '';	
	public String getbutton(){return button;}  		
	public String vieworedit = '';
	public String getvieworedit(){return vieworedit;}  
    
    List<Account> newAccounts = new List<Account> ();
   	List<Account> Accounts = new List<Account> ();
   	public void AccountButton(){button='Account';}
    public List<Account> getAccounts() {
    	Schema.DescribeSObjectResult dsoResult = Account.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
    	String SOQLDetail = ' SELECT '+fieldNames+' FROM Account ORDER BY Name limit 300';        
    	Accounts = Database.query(SOQLDetail);  
    	return Accounts; 
    }
    //public void CreateAccountButton(){vieworedit='edit';}
    
    //Location
    List<SVMXC__Site__c> newLocations = new List<SVMXC__Site__c>();
    List<SVMXC__Site__c> Locations = new List<SVMXC__Site__c>();
    public void LocationButton(){button='Location';}
    public List<SVMXC__Site__c> getLocations() {
    	Schema.DescribeSObjectResult dsoResult = SVMXC__Site__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Site__c.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
    	String SOQLDetail = ' SELECT '+fieldNames+' FROM SVMXC__Site__c ORDER BY Name limit 300';        
    	Locations = Database.query(SOQLDetail);  
    	return Locations; 
    }
    
    //Technician
    List<SVMXC__Service_Group_Members__c> newTechs = new List<SVMXC__Service_Group_Members__c>();
    List<SVMXC__Service_Group_Members__c> Techs = new List<SVMXC__Service_Group_Members__c>();
    public void TechButton(){button='Tech';}
    public List<SVMXC__Service_Group_Members__c> getTechs() {
    	Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Group_Members__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Group_Members__c.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
    	String SOQLDetail = ' SELECT '+fieldNames+' FROM SVMXC__Service_Group_Members__c ORDER BY Name limit 300';        
    	Techs = Database.query(SOQLDetail);  
    	return Techs; 
    }
    
    List<Product2> Products = new List<Product2> ();
    List<Product2> newProducts = new List<Product2> ();
    public void ProductButton(){button='Product';}
    public List<Product2> getProducts() {
    	Schema.DescribeSObjectResult dsoResult = Product2.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.Product2.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
    	String SOQLDetail = ' SELECT '+fieldNames+' FROM Product2 ORDER BY Name limit 300';        
    	Products = Database.query(SOQLDetail);  
    	return Products; 
    }
    
    List<SVMXC__Installed_Product__c> newInstalledProducts = new List<SVMXC__Installed_Product__c> ();
    List<SVMXC__Installed_Product__c> InstalledProducts = new List<SVMXC__Installed_Product__c> ();
    public void IPButton(){button='IP';} 
    public List<SVMXC__Installed_Product__c> getInstalledProducts() {
    	//if(InstalledProducts.size()==0) 
    	ViewInstalledProducts();
    	return InstalledProducts; 
    }
    public void ViewInstalledProducts(){	
    	Schema.DescribeSObjectResult dsoResult = SVMXC__Installed_Product__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Installed_Product__c.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
    	String sortFullExp = sortExpression + ' ' + sortDirection;
    	String SOQLDetail = ' SELECT '+fieldNames+' FROM SVMXC__Installed_Product__c ORDER BY '+sortFullExp+' limit 300';        
    	InstalledProducts = Database.query(SOQLDetail);   
    }
    
    List<SVMXC__Service_Order__c> WorkOrders = new List<SVMXC__Service_Order__c> ();
    List<SVMXC__Service_Order__c> newWorkOrders = new List<SVMXC__Service_Order__c> ();
    public void WorkOrderButton(){button='WorkOrder';}
    public List<SVMXC__Service_Order__c> getWorkOrders() {
    	ViewWorkOrders();
    	return WorkOrders;
    }
    public void ViewWorkOrders(){	
    	Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Order__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
    	String sortFullExp = sortExpression + ' ' + sortDirection;
    	String SOQLDetail = ' SELECT '+fieldNames+' FROM SVMXC__Service_Order__c ORDER BY '+sortFullExp+' limit 300';        
    	WorkOrders = Database.query(SOQLDetail);  	 
    }
    
	//current feed items
	/*
    transient List<FeedItem> FeedItems = new List<FeedItem>();   
    public void FeedItemsButton(){button='FeedItems';}
    public List<FeedItem> getFeedItems() {
    	ViewFeedItems(); 
    	return FeedItems; 
    } 
    public void ViewFeedItems(){
     	Schema.DescribeSObjectResult dsoResult = FeedItem.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.FeedItem.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
        fieldNames += ', Parent.Name, CreatedBy.Name';
        fieldNames += ', (Select Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, IsDeleted, InsertedById From FeedComments)';    	
    	String SOQLDetail = ' SELECT '+fieldNames+' FROM FeedItem limit 100';        
    	FeedItems = Database.query(SOQLDetail);      		 
    }
    
    //new feed items 
    public class cFeedItem{
    	public FeedItem fitem{get; set;}
    	public String objectName{get;set;}
    	public DummySObject sobj{get;set;}   //obj=Schema.getGlobalDescribe().get(objName).newSObject(); sObj.put('lastName' , 'TestFromCode') ;>
    	public Integer feednumber{get;set;}
    	public cFeedItem (FeedItem f, String objName, DummySObject o, Integer i){
    		fitem = f;
    		objectName = objName;
    		sobj = o;
    		feednumber = i;
    	}
    } 
    public List<cFeedItem> cFeedItems{
    	get{
    		if(cFeedItems==null) {
    			cFeedItems = new List<cFeedItem>();    		
    			cFeedItems.add(new cFeedItem(new FeedItem(), null, new DummySObject(), 0));
    		}
    		return cFeedItems;
    	}
    	set; 
    }    
    public void addFeedRow(){    	
    	cFeedItems.add(new cFeedItem(new FeedItem(), null, new DummySObject(), cFeeditems.size()));
    }
    public void removeFeedRow(){
    	Integer i = cFeedItems.size();
    	cFeedItems.remove(i-1);
    }
    public String matchFeedId {get;set;}    
    public void updateParentId(){
    	for(cFeedItem i: cFeedItems){
    		if(i.fitem.id==matchFeedId){
    			if(i.objectName=='Account'){
    				i.fitem.ParentId = [select id from Account where id=:i.sobj.so.SVMXC__Company__c limit 1].id;
    			}
    		}
    	}
    
    }
    
    // Dummy sobjects
    public class DummySObject{
    	public DummySObject(){}
    	public SVMXC__Service_Order__c so{get;set;} //Account, Contact, Case, Installed Product	
    }
    
    //picklist
    public List<selectOption> getObjectList(){
    	List<selectOption> options = new List<selectOption>();
    	options.add(new selectOption('', '- Select -'));
    	options.add(new selectOption('Account', 'Account'));
    	options.add(new selectOption('Contact', 'Contact'));
    	options.add(new selectOption('Installed Product', 'Installed Product'));
    	return options;
    }           
    
	//Work in progress
	public PageReference CreateNew(){
		if(button=='Account') insert newAccounts;
		if(button=='WorkOrder') insert newWorkOrders;
		if(button=='IP') insert newInstalledProducts;
		if(button=='Product') insert newProducts;
		if(button=='Location') insert newLocations;
		if(button=='Tech') insert newTechs;
		if(button=='FeedItems'){ 
			List<FeedItem> fitems = new List<FeedItem>();
			for(cFeeditem fi: cFeedItems){
				fitems.add(fi.fitem);
			}
			insert fitems; cFeeditems=new List<cFeedItem>();
		}
		return null;
	} 
	//
	*/
	public PageReference QuickSave() { 
		if(button=='Account') update Accounts;
		if(button=='WorkOrder') update WorkOrders;
		if(button=='IP') update InstalledProducts;
		if(button=='Product') update Products;
		if(button=='Location') update Locations;
		if(button=='Tech') update Techs;		
		return null;
	}
	
	public PageReference Save(){
		if(button=='Account') update Accounts;
		if(button=='Location') update Locations;
		if(button=='Tech') update Techs;
		if(button=='WorkOrder') update WorkOrders;
		if(button=='IP') update InstalledProducts;
		if(button=='Product') update Products;		
		PageReference homepage = new PageReference('https://na7.salesforce.com/home/home.jsp');
		return homepage;
	}
	
	//correct date
	public void updateDateButton(){
		button='updateDate';
    	//RefOrder = [select Id, Name, SVMXC__Preferred_Start_Time__c, SVMXC__Preferred_End_Time__c from SVMXC__Service_Order__c limit 1];
    	RefOrder = new SVMXC__Service_Order__c();
    	//if(RefOrder.SVMXC__Preferred_Start_Time__c==null){
    		RefOrder.SVMXC__Preferred_Start_Time__c=System.now();
    	//} // Give Reference Date for now
	}
	public SVMXC__Service_Order__c RefOrder{get; set;}
	public Decimal CalculateDate{
		get{		
			if(RefOrder!=null && RefOrder.SVMXC__Preferred_Start_Time__c!=null && RefOrder.SVMXC__Preferred_End_Time__c!=null){
				calculationReady=true; System.debug('calculationReady:'+calculationReady);
				if(RefOrder.SVMXC__Preferred_Start_Time__c==null||RefOrder.SVMXC__Preferred_End_Time__c==null) return 0;
				Decimal n = RefOrder.SVMXC__Preferred_Start_Time__c.getTime() - RefOrder.SVMXC__Preferred_End_Time__c.getTime();
				n = (n/(60.0*60*24*1000)).setScale(0);
				return n;
			}else{
				calculationReady=false; System.debug('calculationReady:'+calculationReady);
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Both dates are required for manual updates!'));
				return 0;
			}
		} 
		set{calculationReady=true;}
	}
	public Boolean calculationReady{get; set;}
	public PageReference CommitDates(){
		String fieldNames1='Id, Name, SVMXC__Scheduled_Date_Time__c ';
    	String SOQLDetail1 = 'Select '+fieldNames1+' FROM SVMXC__Service_Order__c where SVMXC__Scheduled_Date_Time__c!=null limit 100';        
    	WorkOrders = Database.query(SOQLDetail1);  
    	for(SVMXC__Service_Order__c WO: WorkOrders){   		
    		WO.SVMXC__Scheduled_Date_Time__c = WO.SVMXC__Scheduled_Date_Time__c.addDays(CalculateDate.intValue());    		
    	}	 
    	update WorkOrders;
    	String fieldNames2='Id, SVMXC__StartDateTime__c, SVMXC__EndDateTime__c ';
    	String SOQLDetail2 = ' SELECT '+fieldNames2+' FROM SVMXC__SVMX_Event__c';    
    	List<SVMXC__SVMX_Event__c> SVMXEvents = Database.query(SOQLDetail2); 
    	for(SVMXC__SVMX_Event__c event: SVMXEvents){  
    		event.SVMXC__StartDateTime__c = event.SVMXC__StartDateTime__c.addDays(CalculateDate.intValue());   
	    	event.SVMXC__EndDateTime__c = event.SVMXC__EndDateTime__c.addDays(CalculateDate.intValue());  
    	}
    	update SVMXEvents;
    	String fieldNames3='Id, StartDateTime, EndDateTime ';
    	String SOQLDetail3 = ' SELECT '+fieldNames3+' FROM Event';    
    	List<Event> SFDCEvents = Database.query(SOQLDetail3); 
    	for(Event event: SFDCEvents){    		
    		event.StartDateTime = event.StartDateTime.addDays(CalculateDate.intValue());   
    		event.EndDateTime = event.EndDateTime.addDays(CalculateDate.intValue());  		
	    }	 
	    update SFDCEvents;
		return null;
	}
	public PageReference AutoDateCorrect(){
		Integer daysbetween=0;
		// update Work Order Scheduled Date
		String fieldNames1='Id, Name, SVMXC__Scheduled_Date_Time__c ';
    	String SOQLDetail1 = 'Select '+fieldNames1+' FROM SVMXC__Service_Order__c where SVMXC__Scheduled_Date_Time__c!=null Order by SVMXC__Scheduled_Date_Time__c ASC limit 100';        
    	WorkOrders = Database.query(SOQLDetail1);  
    	if(WorkOrders.size()>0){
    		daysbetween = WorkOrders[0].SVMXC__Scheduled_Date_Time__c.date().daysBetween(System.today());
	    	System.debug('daysbetween:'+daysbetween);
	    	for(SVMXC__Service_Order__c WO: WorkOrders){    		
	    		WO.SVMXC__Scheduled_Date_Time__c = WO.SVMXC__Scheduled_Date_Time__c.addDays(daysbetween);    		
	    	}	 
	    	update WorkOrders;
    	}
    	//update ServiceMax Event dates (for Dispatch Console)
    	String fieldNames2='Id, SVMXC__StartDateTime__c, SVMXC__EndDateTime__c ';
    	String SOQLDetail2 = 'Select '+fieldNames2+' FROM SVMXC__SVMX_Event__c ORDER BY SVMXC__StartDateTime__c ASC';    
    	List<SVMXC__SVMX_Event__c> SVMXEvents = Database.query(SOQLDetail2);
    	System.debug('SVMXEvents[0].SVMXC__StartDateTime__c'+SVMXEvents[0].SVMXC__StartDateTime__c); 
    	System.debug('SVMXEvents.size:'+SVMXEvents.size() );
    	if(SVMXEvents.size()>0){
    		daysbetween = SVMXEvents[0].SVMXC__StartDateTime__c.date().daysBetween(System.today());
	    	System.debug('daysbetween:'+daysbetween);
	    	for(SVMXC__SVMX_Event__c event: SVMXEvents){    		
	    		event.SVMXC__StartDateTime__c = event.SVMXC__StartDateTime__c.addDays(daysbetween);   
	    		event.SVMXC__EndDateTime__c = event.SVMXC__EndDateTime__c.addDays(daysbetween);  		
	    	}	 
	    	update SVMXEvents;
    	}
    	//update Salesforce Event dates (for Dispatch Console)
    	String fieldNames3='Id, StartDateTime, EndDateTime ';
    	String SOQLDetail3 = ' SELECT '+fieldNames3+' FROM Event ORDER BY StartDateTime ASC';    
    	List<Event> SFDCEvents = Database.query(SOQLDetail3); 
    	System.debug('SFDCEvents[0].StartDateTime:'+SFDCEvents[0].StartDateTime);
    	System.debug('SFDCEvents.size:'+SFDCEvents.size() );
    	if(SFDCEvents.size()>0){
    		daysbetween = SFDCEvents[0].StartDateTime.date().daysBetween(System.today());
	    	System.debug('daysbetween:'+daysbetween);
	    	for(Event event1: SFDCEvents){    		
	    		event1.StartDateTime = event1.StartDateTime.addDays(daysbetween);   
	    		event1.EndDateTime = event1.EndDateTime.addDays(daysbetween);  		
	    	}	 
	    	update SFDCEvents;
    	}
		PageReference homepage = new PageReference('https://na7.salesforce.com/home/home.jsp');
		return null;
		return homepage;
	}
	
	//sorting
	public String sortDirection = 'ASC';
	public String sortExp = 'Id';
	public String sortExpression{
		get{return sortExp;}
		set{
			if(value==sortExp) sortDirection = (sortDirection=='ASC')? 'DESC':'ASC';
			else sortDirection ='ASC';
			sortExp = value;
		}
	}
	public String getSortDirection(){
		if(sortExpression==null||sortExpression==''){return 'ASC';}
		else{return sortDirection;}
	}
	public void setSortDirection(String value){
		sortDirection = value;
	}
	
	//Utility
	// Methods used in generating Dynamic SOQL    
    public static List<String> getFieldList( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields){
        List<String> fieldList = new List<String>();        
        //build dynamic list of fieldnames
        for (String fieldKey : fieldMap.keySet()){
            Schema.SObjectField fsObj = fieldMap.get(fieldKey);
            Schema.DescribeFieldResult f = fsObj.getDescribe();
            String fieldName = f.getName();            
            if (selectAllFields){ fieldList.add(fieldName); 
        	} else { if (f.getName()=='Id' || f.isNameField() || f.isCustom()) { fieldList.add(fieldName);}
            }
    	}        
    	return fieldList;
    }
    public static String getFieldNamesFromList(List<String> fieldList){
        String fieldNames = '';
        for (String field : fieldList) {
            if (fieldNames.length()>0) {
                fieldNames += ',';
            }
            fieldNames += field;
        }        
        return fieldNames;
    }
    
	/***** Unit Test Methods *****/
	static testmethod void test1(){			
        //Test coverage for the ServiceMaxMassDataEdit    
        Account a = new Account(Name='Test acct'); insert a;
            
        RecordType[] rt = [select id, name from RecordType where SobjectType='SVMXC__Service_Order__c'];   
        SVMXC__Service_Order__c wo = new SVMXC__Service_Order__c();
        wo.SVMXC__Scheduled_Date_Time__c = system.now();
        wo.SVMXC__Order_Status__c = 'Open'; wo.SVMXC__Order_Type__c ='Field Service'; wo.SVMXC__Priority__c ='Medium';
        wo.SVMXC__Company__c = a.Id;
        if(rt.size()>0) wo.RecordTypeId = rt[0].id;
        //insert wo;
        
        SVMXC__SVMX_Event__c svmxe = new SVMXC__SVMX_Event__c();
        svmxe.SVMXC__StartDateTime__c = system.now();
        svmxe.SVMXC__EndDateTime__c = system.now()+2;
        insert svmxe;
        
        Event e = new Event();
        e.StartDateTime = system.now()+3;
        e.EndDateTime = system.now()+5;
        insert e;
        
        PageReference pageRef = Page.ServiceMaxMassDataEdit;
        Test.setCurrentPageReference(pageRef);
        
        Test.startTest();
        ServiceMaxMassDataEdit myPageCon1 = new ServiceMaxMassDataEdit();
		myPageCon1.AccountButton(); myPageCon1.getAccounts(); 
		myPageCon1.LocationButton(); myPageCon1.getLocations(); 
		myPageCon1.TechButton(); myPageCon1.getTechs();
		myPageCon1.getWorkOrders(); myPageCon1.getProducts(); myPageCon1.getInstalledProducts();
		myPageCon1.getSortDirection(); myPageCon1.setSortDirection('ASC'); myPageCon1.QuickSave(); myPageCon1.Save();
		myPageCon1.updateDateButton(); 
		myPageCon1.AutoDateCorrect();
		myPageCon1.CalculateDate = 2; myPageCon1.CommitDates();
		Test.stopTest(); 	
		
	}
	
}