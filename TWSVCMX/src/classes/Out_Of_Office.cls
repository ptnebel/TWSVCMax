public with sharing class Out_Of_Office {
	public static void changes(Out_of_Office__c[] oofs){
		// List Updates 
		List<SVMXC__Service_Order__c> updateWOs = new List<SVMXC__Service_Order__c>();
		List<Event> deleteEvents = new List<Event>();
		List<OpenActivity> deleteOpenActivity = new List<OpenActivity>();
		List<Event> newEvents = new List<Event>();
		 
		// Rescheduled Queue Id
		QueueSobject[] RescheduledQueue = [Select id, Queue.Name, QueueId From QueueSobject q where Queue.Name='Rescheduled Order Queue' limit 1]; 
		if(RescheduledQueue.size()==1){
			System.debug('RescheduledQueueName: '+RescheduledQueue[0].Queue.Name);
			System.debug('RescheduledQueueId: '+RescheduledQueue[0].QueueId);	 // Rescheduled Queue Id	
		}
		
		// Query through the out of offices
		Set<Id> Idset = new Set<Id>();
		for (Out_of_Office__c oof: oofs)
  			Idset.add(oof.Id);
  		
  		List<Out_of_Office__c> outofoffices = [select id, Name, Begin_Time__c, End_Time__c, Reason__c, CreatedById from Out_of_Office__c where id=:idset];
  		List<Event> events = [select id, whatid, whoid, StartDateTime, EndDateTime, ShowAs, Subject, OwnerId From Event Where OwnerId=:UserInfo.getUserId() AND (EndDateTime>:Datetime.now()) ];    		
  		List<SVMXC__Service_Order__c> workorders = [select id, Name, SVMXC__Scheduled_Date_Time__c, (Select Subject From OpenActivities where Subject='Work Order Assigned') from SVMXC__Service_Order__c where SVMXC__Group_Member__r.SVMXC__Salesforce_User__c=:UserInfo.getUserId() AND SVMXC__Scheduled_Date_Time__c!=null];  	  		
  		  		  		
  		for(Out_of_Office__c office:outofoffices){
  			/*
  			// Work Orders   			
  			for(SVMXC__Service_Order__c workorder: workorders){
  				if(workorder.SVMXC__Scheduled_Date_Time__c>office.Begin_Time__c && workorder.SVMXC__Scheduled_Date_Time__c<office.End_Time__c){
  					workorder.SVMXC__Group_Member__c = null;
  					workorder.SVMXC__Service_Group__c = null;
  					workorder.SVMXC__Scheduled_Date_Time__c=null;
  					workorder.OwnerId = RescheduledQueue[0].QueueId;
  					updateWOs.add(workorder);
  				}
  			}
  			*/
  			
  			//Create Out of Office Event
	  		Event newE = new Event();
	  		newE.StartDateTime = office.Begin_Time__c;
	  		newE.EndDateTime = office.End_Time__c;
	  		newE.ShowAs = 'OutOfOffice';
	  		newE.Subject = 'Out of Office';
	  		newE.OwnerId = UserInfo.getUserId();
	  		newEvents.add(newE);
  		
  			// Events and/or Work Orders
  			for(Event e:events){
  				if( (e.StartDateTime<=office.Begin_Time__c&&e.EndDateTime>=office.Begin_Time__c)
  					|| (e.StartDateTime<=office.End_Time__c&&e.EndDateTime>=office.End_Time__c)
  					|| (e.StartDateTime>=office.Begin_Time__c&&e.EndDateTime<=office.End_Time__c)  					
  				){
  					//Delete the Work Order Event
  					deleteEvents.add(e);  															
  					
  					//Work Order option
  					SVMXC__Service_Order__c workorder = new SVMXC__Service_Order__c();
  					workorder.id = e.WhatId; 
  					workorder.SVMXC__Group_Member__c = null;
  					workorder.SVMXC__Service_Group__c = null;
  					workorder.SVMXC__Scheduled_Date_Time__c=null;
  					workorder.OwnerId = RescheduledQueue[0].QueueId;
  					if(workorder.id!=null) updateWOs.add(workorder);
  					
  				}
  			}
  		}  		
  		if(updateWOs.size()>0) update updateWOs;  
  		if(deleteEvents.size()>0) delete deleteEvents;  		  				 		
  		if(newEvents.size()>0) insert newEvents;  		
	}
	
	static testmethod void test1(){
		Case c1 = new Case(); 
		c1.Origin = 'Phone'; c1.Status='New';
		insert c1;
		
		Event newE = new Event(); 
		newE.StartDateTime = System.now();
  		newE.EndDateTime = System.now()+7;
  		newE.ShowAs = 'OutOfOffice';
  		newE.Subject = 'Out of Office';
  		insert newE;
  		
		Out_of_Office__c oof = new Out_of_Office__c();
		oof.Begin_Time__c = datetime.now().addHours(-1);
		oof.End_Time__c = datetime.now().addHours(1);
		insert oof;
	}
}