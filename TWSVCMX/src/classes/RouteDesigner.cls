public with sharing class RouteDesigner {
	public RouteDesigner(){}
	public SVMXC__Service_Order__c dummyObj{
		get{
			if(dummyObj==null){
				dummyObj = new SVMXC__Service_Order__c();	
				dummyObj.SVMXC__Scheduled_Date__c=date.today();			
			} 			
			return dummyObj;
		}
		set;
	} 
	public Boolean optimizedRoute {get;set;}
	public List<SVMXC__Service_Order__c> workOrders{
		get{
			if(workOrders==null){regetWorkOrders();} 
			return workOrders;
		}
		set;
	}
	public SVMXC__Service_Group_Members__c Tech {
		get{
			if(dummyObj.SVMXC__Group_Member__c!=null) 
				Tech = [select id, SVMXC__Street__c, SVMXC__City__c, SVMXC__State__c, SVMXC__Zip__c, SVMXC__Latitude__c, SVMXC__Longitude__c from SVMXC__Service_Group_Members__c where id=:dummyObj.SVMXC__Group_Member__c limit 1];
			return Tech;
		}
		set;
	}
	public String TechAddress{
		get{
			String techaddress ='';
			if(Tech!=null){
				if(Tech.SVMXC__Street__c!=null) techaddress = Tech.SVMXC__Street__c;
				if(Tech.SVMXC__City__c!=null) techaddress += ', '+Tech.SVMXC__City__c;
				if(Tech.SVMXC__State__c!=null) techaddress += ', '+Tech.SVMXC__State__c;
				if(Tech.SVMXC__Zip__c!=null) techaddress += ' '+Tech.SVMXC__Zip__c;
			}
			return techaddress;
		}
		set;
	}
	public String startAddress{get{if(startAddress=='')startAddress=techaddress; return startAddress;}set;}
	public String endAddress{get{if(endAddress=='')endAddress=techaddress; return endAddress;}set;}
	public void regetWorkOrders(){
		System.debug('Running regetWorkOrders');
		workOrders = new List<SVMXC__Service_Order__c>();
		//System.debug('regetWorkOrders - dummyObj.SVMXC__Group_Member__c:'+dummyObj.SVMXC__Group_Member__c);
		//System.debug('regetWorkOrders - dummyObj.SVMXC__Scheduled_Date__c.year():'+dummyObj.SVMXC__Scheduled_Date__c.year());
		Time tm = Time.newInstance(0,0,0,0);
		Date D = Date.newInstance(dummyObj.SVMXC__Scheduled_Date__c.year(),dummyObj.SVMXC__Scheduled_Date__c.month(),dummyObj.SVMXC__Scheduled_Date__c.day());
		DateTime ScheduledDate =DateTime.newInstance(dummyObj.SVMXC__Scheduled_Date__c, tm);
		DateTime OneDayAfterScheduledDate = DateTime.newInstance(dummyObj.SVMXC__Scheduled_Date__c+1, tm);
		if(dummyObj.SVMXC__Group_Member__c!=null){
			workOrders = [select id, Name, SVMXC__Company__c, SVMXC__Group_Member__c, SVMXC__Scheduled_Date__c, SVMXC__Scheduled_Date_Time__c, SVMXC__Street__c, SVMXC__City__c, SVMXC__State__c, SVMXC__Zip__c
				from SVMXC__Service_Order__c 
				where SVMXC__Group_Member__c=:dummyObj.SVMXC__Group_Member__c
				AND (
					(SVMXC__Scheduled_Date_Time__c >=: ScheduledDate AND SVMXC__Scheduled_Date_Time__c <: OneDayAfterScheduledDate)
					OR
					(SVMXC__Scheduled_Date__c =: d)
				)	 
				ORDER BY SVMXC__Scheduled_Date_Time__c ASC
				limit 20];
		}
		//set workOrderHeader too		
		woHeaders=new List<workOrderHeader>();
		for(SVMXC__Service_Order__c ord: workOrders){
			workOrderHeader woH = new workOrderHeader();
			woH.WOSelected=true;
			woH.o = ord;
			woH.address ='';
			if(ord.SVMXC__Street__c!=null) woH.address+=ord.SVMXC__Street__c;
			if(ord.SVMXC__City__c!=null) woH.address+=', '+ord.SVMXC__City__c;
			if(ord.SVMXC__State__c!=null) woH.address+=', '+ord.SVMXC__State__c;
			if(ord.SVMXC__Zip__c!=null) woH.address+=' '+ord.SVMXC__Zip__c;
			woHeaders.add(woH);
		}
	}
	public List<workOrderHeader> woHeaders{
		get{
			if(woHeaders==null){
				regetWorkOrders();
			}
			return woHeaders;
		} 
		set;
	} 
	public class workOrderHeader{
		public Boolean WOSelected {get{if(WOSelected==null)return false; return WOSelected;}set;}
		public SVMXC__Service_Order__c o{get;set;}		
		public String address{get;set;}
	}
	public List<workOrderHeader> workorderheadersSelected{
		get{
			List<workOrderHeader> tempWOH = new List<workOrderHeader>();
			for(workOrderHeader w:woHeaders){
				if(w.WOSelected==true)tempWOH.add(w);
			}
			return tempWOH;
		}
		set;
	}
	
	
	
	// TEST COVERAGE
	public static testmethod void t1(){		
        PageReference pageRef = Page.RouteDesign;
        Test.setCurrentPageReference(pageRef);
        
        //Create Service Team
        SVMXC__Service_Group__c team = new SVMXC__Service_Group__c();
        team.Name = 'Service Team Name'; 
        insert team;
        
        //Create Technician
        SVMXC__Service_Group_Members__c tech = new SVMXC__Service_Group_Members__c();
        tech.Name = ''; tech.SVMXC__Street__c='Hopyard Rd.'; 
        tech.SVMXC__State__c='CA'; tech.SVMXC__Service_Group__c=team.id;
        insert tech;
        
        //Create Work Order
        SVMXC__Service_Order__c ord = new SVMXC__Service_Order__c();
        ord.SVMXC__Group_Member__c = tech.id;
        ord.SVMXC__Scheduled_Date_Time__c = System.now();
        ord.SVMXC__Scheduled_Date__c = System.today();
        insert ord;
        
        Test.startTest();        
        RouteDesigner myPageCon1 = new RouteDesigner();	
        List<workOrderHeader> testwoH1 = myPageCon1.woHeaders;			
		myPageCon1.dummyObj.SVMXC__Group_Member__c = tech.id;
		myPageCon1.regetWorkOrders();
		SVMXC__Service_Group_Members__c testTech = myPageCon1.Tech; 
		String testaddress = myPageCon1.TechAddress; 
		List<workOrderHeader> testwoH2 = myPageCon1.workorderheadersSelected;
		if(testwoH2.size()>0) testwoH2[0].WOSelected = true;
		
		Test.stopTest();
	} 

}