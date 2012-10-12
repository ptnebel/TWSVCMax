public with sharing class TimeSheet { 
	public TimeSheet(){}
	private final TimeSheet__c timesheet; 
	private final ApexPages.StandardController theController;
	public TimeSheet(ApexPages.StandardController stdController){
		timesheet = (TimeSheet__c)stdController.getRecord();
		theController = stdController;
	}
	
	public PageReference LaborHours(){
		if(ApexPages.currentPage()!=null){ 
			String theId = ApexPages.currentPage().getParameters().get('id');
			System.debug('theId: '+theId);
			TimeSheet__c[] sheets = [select id, Labor_Line_Hours__c, Technician__c, TimeSheet_Status__c, Start_Date__c,End_Date__c From TimeSheet__c where TimeSheet_Status__c='Pending' AND id=:theId];
			List<SVMXC__Service_Order_Line__c> laborsToUpdate = new List<SVMXC__Service_Order_Line__c>();
			
			List<TimeSheet__c> updateSheets = new List<TimeSheet__c>();	
				
			for(TimeSheet__c sheet: sheets){
			//	if(sheet.TimeSheet_Status__c=='Submitted'){ 
					Double laborHrs = 0;
					// Query for technician and associated work details
					SVMXC__Service_Group_Members__c[] techs = [select id, name, (select id, SVMXC__Start_Date_and_Time__c, SVMXC__End_Date_and_Time__c, Hours_Worked__c from SVMXC__Service_Order_Line__r where SVMXC__Line_Type__c='Labor') from SVMXC__Service_Group_Members__c where id=:sheet.Technician__c];
					System.debug('techs size:'+techs.size());
					for(SVMXC__Service_Group_Members__c tech: techs){		
						System.debug('tech name:'+tech.Name);		
						List<SVMXC__Service_Order_Line__c> labors = tech.SVMXC__Service_Order_Line__r;
						System.debug('labors size:'+labors.size());
						for(SVMXC__Service_Order_Line__c labor: labors){
							datetime sheetStartTime = Datetime.newinstance(sheet.Start_Date__c.year(), sheet.Start_Date__c.month(),sheet.Start_Date__c.day()-1);
							datetime sheetEndTime = Datetime.newinstance(sheet.End_Date__c.year(), sheet.End_Date__c.month(),sheet.End_Date__c.day()+1);
							System.debug('sheet times: '+sheetStartTime+' '+sheetEndTime);
							System.debug('labor times: '+labor.SVMXC__Start_Date_and_Time__c+' '+labor.SVMXC__End_Date_and_Time__c);
							if(labor.SVMXC__Start_Date_and_Time__c >= sheetStartTime && labor.SVMXC__End_Date_and_Time__c <= sheetEndTime){
								laborHrs += labor.Hours_Worked__c;
								System.debug('labor hrs:'+laborHrs);
								
								Boolean newlabor = true;
								for(SVMXC__Service_Order_Line__c l:laborsToUpdate){
									if(labor.id==l.id) newlabor=false;								
								}
								if(newlabor==true) {
									System.debug('newlabor was set to true');
									labor.Time_Sheet__c = sheet.id; 
									laborsToUpdate.add(labor);									
								}
							}
						}					
					}
					TimeSheet__c ts = new TimeSheet__c(id=sheet.id, Labor_Line_Hours__c = laborHrs);
					if(laborHrs!=sheet.Labor_Line_Hours__c || sheet.Labor_Line_Hours__c==null) updateSheets.add(ts);
			//	}
			}
			if(updateSheets.size()>0)update updateSheets;
			if(laborsToUpdate.size()>0) update laborsToUpdate;
			
			PageReference pageRef = new PageReference('/'+theId);
			pageRef.setRedirect(true);
			System.debug('pageRef: '+pageRef);
			return pageRef;
		}
		return null;
	}
	
	static testMethod void Timesheet_Test(){
    	Account ac = new Account(
                Name ='Account',
                ShippingStreet='ABC',
                ShippingCity='PQR ',
                ShippingState = 'XYZ',
                ShippingPostalCode='111',
                ShippingCountry='XYZ'
                ); 
        insert ac; 
        Contact  ct = new Contact(LastName='Last',AccountId =ac.Id); 
        insert ct;  
        //Create Installed Product
        SVMXC__Installed_Product__c ip = new SVMXC__Installed_Product__c (
				SVMXC__Company__c = ac.Id , 
				SVMXC__Contact__c = ct.Id ,
				Name = 'abc'
				);
        insert ip;
        //Create Case                
        Case cs = new Case(Status ='New', Priority = 'Medium', 
                Origin = 'Email', 
                SVMXC__Component__c = ip.id,                                         
                ContactId =ct.Id,
                AccountId=ac.Id
                ); 
        insert cs;   
        //Create Service Team
        SVMXC__Service_Group__c steam = new SVMXC__Service_Group__c(Name = 'Test Service Team');
        insert steam;
        //Create Technician
        SVMXC__Service_Group_Members__c tech = new SVMXC__Service_Group_Members__c(
				SVMXC__Service_Group__c = steam.id,
				Name = 'Test Technician'
				);
        insert tech;								
        //Create Work Order
		SVMXC__Service_Order__c svo = new SVMXC__Service_Order__c (
                SVMXC__Case__c = cs.Id ,
                SVMXC__Component__c = ip.id,
                SVMXC__Company__c = ac.Id , 
                SVMXC__Order_Status__c = 'Open',
                SVMXC__Priority__c ='Medium',
                SVMXC__Order_Type__c='Field Service'
                );                           
        insert svo;    
        //Work Order Detail Line
        SVMXC__Service_Order_Line__c svol = new SVMXC__Service_Order_Line__c(
				SVMXC__Service_Order__c = svo.id,
				SVMXC__Line_Type__c = 'Labor',
				SVMXC__Start_Date_and_Time__c = System.now(),
				SVMXC__End_Date_and_Time__c = System.now()+1,
				SVMXC__Group_Member__c = tech.id
				);
        insert svol;
        //Create TimeSheet
        TimeSheet__c ts = new TimeSheet__c( 
        		Technician__c = tech.id,
				Start_Date__c = System.today()-5,
				End_Date__c = System.today()+5,
				TimeSheet_Status__c='Pending'
				); 
		insert ts;
        ApexPages.StandardController mc = new Apexpages.Standardcontroller(ts);
        Timesheet myPageCon = new TimeSheet(mc);
        myPageCon.LaborHours();
        ts.TimeSheet_Status__c='Submitted'; update ts;
    }
}