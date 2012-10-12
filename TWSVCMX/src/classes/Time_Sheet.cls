public with sharing class Time_Sheet {
	public Time_Sheet(){}
	public TimeSheet2__c timesheet{get;set;} 
	private final ApexPages.StandardController theController;
	public Time_Sheet(ApexPages.StandardController stdController){
		timesheet = (TimeSheet2__c)stdController.getRecord();
		theController = stdController;
	}

	public String theId;
	public List<TimeSheet2__c> sheets = new List<TimeSheet2__c>();
	public TimeSheet2__c sheet{get;set;}
	public List<Time_Entry2__c> currentEntries = new List<Time_Entry2__c>();
	public List<Time_Entry2__c> getcurrentEntries() { if(currentEntries.size()==0){Get_Time_Entries();} return currentEntries;}
	public List<TimeSheet2__c> updateSheets = new List<TimeSheet2__c>();	
	public List<Time_Entry2__c> insertEntries = new List<Time_Entry2__c>();
	public List<Time_Entry2__c> updateEntries = new List<Time_Entry2__c>();
	
	public List<Event> currentEvents = new List<Event>();
	public List<SVMXC__SVMX_Event__c> currentSEvents = new List<SVMXC__SVMX_Event__c>();
	public List<Event> newEvents = new List<Event>();  // User created events
	public List<Event> updateEvents = new List<Event>();
	public List<Event> deleteEvents = new List<Event>(); 
	
	public void resetData(){
		String theId='';
		sheets = new List<TimeSheet2__c>();
		sheet = new TimeSheet2__c();
		//currentEntries = new List<Time_Entry2__c>();
		updateSheets = new List<TimeSheet2__c>();	
		insertEntries = new List<Time_Entry2__c>(); updateEntries = new List<Time_Entry2__c>();
		newEvents = new List<Event>(); updateEvents = new List<Event>(); deleteEvents = new List<Event>();
		currentEvents=new List<event>();  currentSEvents = new List<SVMXC__SVMX_Event__c>();
	}
	public void Get_Time_Entries(){
		resetData();
		if(ApexPages.currentPage()!=null){ 
			theId = ApexPages.currentPage().getParameters().get('id');
			System.debug('theId: '+theId);

			sheets = [select id, Name, Technician__c, Use_Calendar_Events__c, Use_Work_Detail_Labor_Lines__c, Technician__r.Name, Technician__r.SVMXC__Salesforce_User__c, Status__c, Start_Date__c,End_Date__c  
				,(select id, Name, Hours__c, Start_Time__c, End_Time__c, Type__c, Work_Order__c, Work_Details__c, Event_Id__c, Event_Type__c from Time_Entries2__r Order By Start_Time__c)
				From TimeSheet2__c where id=:theId limit 1];				
			sheet = sheets[0];
			currentEntries = sheet.Time_Entries2__r;
			System.debug('sheet.Technician__r.SVMXC__Salesforce_User__c: '+sheet.Technician__r.SVMXC__Salesforce_User__c);
			
			if(sheet.Use_Calendar_Events__c==true){  //checked on the TimeSheet to use Calendar Events
				for(SVMXC__SVMX_Event__c seve:[Select SVMXC__WhoId__c, SVMXC__WhatId__c, SVMXC__Technician__c, SVMXC__StartDateTime__c, SVMXC__Service_Team__c, SVMXC__EndDateTime__c, SVMXC__Description__c, Name, Id From SVMXC__SVMX_Event__c
					where SVMXC__Technician__c=:sheet.Technician__c 
					AND ((SVMXC__StartDateTime__c<=:sheet.End_Date__c AND SVMXC__StartDateTime__c>=:sheet.Start_Date__c)OR
					(SVMXC__EndDateTime__c>=:sheet.Start_Date__c AND SVMXC__EndDateTime__c<=:sheet.End_Date__c) OR
					(SVMXC__StartDateTime__c<=:sheet.Start_Date__c AND SVMXC__EndDateTime__c>=:sheet.End_Date__c)
					)]){
					Time_Entry2__c editEntry = new Time_Entry2__c();
					currentSEvents.add(seve);
					Boolean EntryExists=false;
					for(Time_Entry2__c e:currentEntries){
						if(e.Event_Id__c == seve.id){
							EntryExists=true;
							editEntry = e;
						}
					}
					editEntry.Name = seve.Name;
					editEntry.End_Time__c = seve.SVMXC__EndDateTime__c;
					editEntry.Event_Id__c = seve.id;	
					editEntry.Event_Type__c = 'ServiceMax Event';		
					if(seve.SVMXC__WhatId__c!=null){
						Id sid = seve.SVMXC__WhatId__c;
		 				editEntry.Work_Order__c = seve.SVMXC__WhatId__c;
		 				editEntry.Type__c = 'Labor';
					}
					if(EntryExists==true){									
						updateEntries.add(editEntry);
					} else if(EntryExists==false){
						editEntry.TimeSheet__c = sheet.id;
						insertEntries.add(editEntry);
					}				
				}
								
				for(Event eve:[select id, Subject, Description, StartDateTime, EndDateTime, What.Type, WhatId from Event 
					where Owner.Name=:sheet.Technician__r.Name 
					AND ((StartDateTime<=:sheet.End_Date__c+1 AND StartDateTime>=:sheet.Start_Date__c)OR
					(EndDateTime>=:sheet.Start_Date__c AND EndDateTime<=:sheet.End_Date__c+1) OR
					(StartDateTime<=:sheet.Start_Date__c AND EndDateTime>=:sheet.End_Date__c+1)
					)]){ //				
					Time_Entry2__c editEntry = new Time_Entry2__c();
					currentEvents.add(eve);
					Boolean EntryExists=false;
					for(Time_Entry2__c e:currentEntries){
						if(e.Event_Id__c == eve.id){
							EntryExists=true;
							editEntry = e;
						}
					}
					editEntry.Name = eve.Subject;
					editEntry.Start_Time__c = eve.StartDateTime;
					editEntry.End_Time__c = eve.EndDateTime;
					editEntry.Event_Id__c = eve.id;	
					editEntry.Event_Type__c = 'Salesforce';		
					if(eve.what.type == 'SVMXC__Service_Order__c'){
		 				editEntry.Work_Order__c = eve.WhatId;
		 				editEntry.Type__c = 'Labor';
					}
					
					if(EntryExists==true){									
						updateEntries.add(editEntry);
					} else if(EntryExists==false){
						editEntry.TimeSheet__c = sheet.id;
						insertEntries.add(editEntry);
					}
				}	//for
			} //if			
			
			if(sheet.Use_Work_Detail_Labor_Lines__c==true){
				for(SVMXC__Service_Order_Line__c woline:[select id, Name, Hours_Worked__c, SVMXC__End_Date_and_Time__c, SVMXC__Start_Date_and_Time__c from SVMXC__Service_Order_Line__c where ((SVMXC__Start_Date_and_Time__c<=:sheet.End_Date__c+1 AND SVMXC__Start_Date_and_Time__c>=:sheet.Start_Date__c) OR
					(SVMXC__End_Date_and_Time__c>=:sheet.Start_Date__c AND SVMXC__End_Date_and_Time__c<=:sheet.End_Date__c+1) OR
					(SVMXC__Start_Date_and_Time__c<=:sheet.Start_Date__c AND SVMXC__End_Date_and_Time__c>=:sheet.End_Date__c+1)) AND SVMXC__Line_Type__c='Labor' AND SVMXC__Group_Member__c=:sheet.Technician__c
					]){
					Time_Entry2__c editEntry = new Time_Entry2__c();
					Boolean EntryExists=false;
					for(Time_Entry2__c e:currentEntries){
						if(e.Work_Details__c == woline.id){
							EntryExists=true;
							editEntry = e;
						}
					}
					editEntry.Name = woline.Name;
					editEntry.Start_Time__c = woline.SVMXC__Start_Date_and_Time__c;
					editEntry.End_Time__c = woline.SVMXC__End_Date_and_Time__c;
					editEntry.Type__c = 'Labor';
					if(EntryExists==true){									
						updateEntries.add(editEntry);
					} else if(EntryExists==false){
						editEntry.TimeSheet__c = sheet.id;
						insertEntries.add(editEntry);
					}
				}
			}
		}
	}
	
	public void updateFull(){					
		if(updateSheets.size()>0) update updateSheets;  System.debug('updateSheets:'+updateSheets.size());
		if(updateEntries.size()>0) update updateEntries;  System.debug('updateEntries:'+updateEntries.size());
		if(insertEntries.size()>0) insert insertEntries;  System.debug('insertEntries:'+insertEntries.size());	
		//
		//if(insertEvents.size()>0) insert insertEvents;  System.debug('insertEvents:'+insertEvents.size());							
	}
	public PageReference runUpdateFull(){
		Get_Time_Entries();
		updateFull();
		PageReference pageRef = new PageReference('/'+theId);
		pageRef.setRedirect(true);
		System.debug('pageRef: '+pageRef);
		return pageRef;	
	}
	public void runFull(){
		Get_Time_Entries();
		updateFull();
		Get_Time_Entries();
	}
	
	//Manage 
	public TimeSheet2__c sheet1{
		get{
			if(sheet1==null){ Get_Time_Entries();} System.debug('currentEntries1.size(): '+currentEntries.size());
			return sheet; //
		}
		set;
	}
	
    public List<EntryItem> entries = new List<EntryItem>();
    public List<EntryItem> getEntries(){    
    	System.debug('currentEntries.size3(): '+currentEntries.size());	
    	if(entries.size()==0) {    		
    		entries=new List<EntryItem>();
	    	for(Time_Entry2__c l:currentEntries){	    		
    			EntryItem item1 = new EntryItem();    			
				item1.entry = l;	
				item1.StartWeekDay = l.Start_Time__c.format('EEEE');	
				item1.StartMonth = l.Start_Time__c.month().format();
				item1.StartDay = l.Start_Time__c.day().format();
				item1.StartYear = l.Start_Time__c.year().format();
				item1.StartMinute = l.Start_Time__c.minute().format();
				if(l.Start_Time__c.hour()>12){
					item1.StartHour = (l.Start_Time__c.hour()-12).format();	  
					item1.StartAMPM = 'PM';
				} else if(l.Start_Time__c.hour()==12){
					item1.StartHour = l.Start_Time__c.hour().format();	  
					item1.StartAMPM = 'PM';
	    		} else if(l.Start_Time__c.hour()==0){
	    			item1.StartHour = integer.valueof('12').format();
	    			item1.StartAMPM = 'AM';
	    		} else {
					item1.StartHour = l.Start_Time__c.hour().format();
					item1.StartAMPM = 'AM';
				}	
				item1.EndMonth = l.End_Time__c.month().format();
				item1.EndDay = l.End_Time__c.day().format();
				item1.EndYear = l.End_Time__c.year().format();
				item1.EndMinute = l.End_Time__c.minute().format();
				if(l.End_Time__c.hour()>12){
					item1.EndHour = (l.End_Time__c.hour()-12).format();	  
					item1.EndAMPM = 'PM';
				} else if(l.End_Time__c.hour()==12){
					item1.EndHour = l.End_Time__c.hour().format();	  
					item1.EndAMPM = 'PM';
	    		} else if(l.End_Time__c.hour()==0){
	    			item1.EndHour = integer.valueof('12').format();
	    			item1.EndAMPM = 'AM';
	    		} else {
					item1.EndHour = l.End_Time__c.hour().format();
					item1.EndAMPM = 'AM';
				}						
				System.debug('StartHour: '+item1.StartHour+' StartMinute: '+item1.StartMinute);	
				entries.add(item1);    				    			    		
	    	}
    	}	
    	System.debug('entries.size(): '+ItemEntries.size());
    	return entries;
    }
    
    public class EntryItem{
    	public Time_Entry2__c entry{get; set;}
    	public Boolean DelSelected {get{if(DelSelected==null)return false; return DelSelected;}set;}
    	public Boolean EditSelected {get{if(EditSelected==null)return false; return EditSelected;}set;}
    	public String StartWeekDay{get;set;}
    	public String StartMonth{get;set;}
    	public String StartDay{get;set;}
    	public String StartHour{get;set;}
    	public String StartMinute{get;set;}
    	public String StartYear{get;set;}
    	public String StartAMPM{get;set;}
    	public String EndMonth{get;set;}
    	public String EndDay{get;set;}
    	public String EndHour{get;set;}
    	public String EndMinute{get;set;}
    	public String EndYear{get;set;}
    	public String EndAMPM{get;set;}    	
    }
    public List<EntryItem> ItemEntries = new List<EntryItem>();
    public List<EntryItem> getItemEntries(){
    	System.debug('currentEntries.size3(): '+currentEntries.size());
    	if(entries.size()==0) {
    		getEntries();
    	}
    	for(EntryItem i: entries){    		
			Boolean alreadyIn = false;
			for(EntryItem c: ItemEntries){
				if(c.entry.id==i.entry.id) alreadyIn=true;
			}
			if(alreadyIn==false)ItemEntries.add(i);
    				 
    	}
    	System.debug('ItemEntries.size(): '+ItemEntries.size());    	
    	return ItemEntries;
    }
    /*
    public List<LineItem> ItemNonSubscriptions = new List<LineItem>();
    public List<LineItem> getItemNonSubscriptions(){
    	if(items.size()==0) getItems(); 
    	for(LineItem i: items){
    		if(i.product.Type__c=='Implementation') {
    			Boolean alreadyIn = false;
    			for(LineItem c: ItemNonSubscriptions){
    				if(c.line==i.line) alreadyIn=true;
    			}
    			if(alreadyIn==false)ItemNonSubscriptions.add(i);
    		}
    	}
    	return ItemNonSubscriptions;
    }
	*/
	public PageReference Back(){
		PageReference pageRef = new PageReference('/'+theId);
		pageRef.setRedirect(true);
		System.debug('pageRef: '+pageRef);
		return pageRef;
	}
	public PageReference SubmitSheet(){
		timesheet.Status__c = 'Submitted';
		update timesheet;
		PageReference pageRef = new PageReference('/apex/Time_Sheet_Manage?id='+theId);
		pageRef.setRedirect(true); 			
		return pageRef;
	}
	public void updateDates(){
		for(EntryItem li:entries){
			if(li.StartAMPM=='PM' && li.StartHour!='12') { li.StartHour=(integer.valueOf(li.StartHour)+12).format(); }
			if(li.StartAMPM=='AM' && li.StartHour=='12') { li.StartHour=(integer.valueOf(li.StartHour)-12).format(); }
			System.debug('li.StartHour: '+li.StartHour);
			li.entry.Start_Time__c = datetime.newInstance(integer.valueOf(li.StartYear.replace(',','')), integer.valueOf(li.StartMonth), integer.valueOf(li.StartDay), integer.valueOf(li.StartHour), integer.valueOf(li.StartMinute), 0);
			if(li.EndAMPM=='PM' && li.EndHour!='12') { li.EndHour=(integer.valueOf(li.EndHour)+12).format(); }
			if(li.EndAMPM=='AM' && li.EndHour=='12') { li.EndHour=(integer.valueOf(li.EndHour)-12).format(); }
			System.debug('li.EndHour: '+li.EndHour);
			li.entry.End_Time__c = datetime.newInstance(integer.valueOf(li.EndYear.replace(',','')), integer.valueOf(li.EndMonth), integer.valueOf(li.EndDay), integer.valueOf(li.EndHour), integer.valueOf(li.EndMinute), 0);			
		}
	}
    public PageReference QuickSaveEntries(){    	
    	updateDates();
    	List<Time_Entry2__c> uLines = new List<Time_Entry2__c>();
    	for(EntryItem li:entries){
    		uLines.add(li.entry);
    	}    	
		update uLines;
		SaveEntryDataToEvent();
    	PageReference pageRef = new PageReference('/apex/Time_Sheet_Manage?id='+theId);
		pageRef.setRedirect(true); 			
		return pageRef;    	
    }	
    public PageReference SaveEntries(){ 
    	updateDates();   	
    	List<Time_Entry2__c> uLines = new List<Time_Entry2__c>();
    	for(EntryItem li:entries){
    		uLines.add(li.entry);
    	}    	
		update uLines;
		SaveEntryDataToEvent();
    	PageReference pageRef = new PageReference('/'+theId);
		pageRef.setRedirect(true); 			
		return pageRef;    	
    }
    public void SaveEntryDataToEvent(){
    	for(EntryItem li:entries){
    		Boolean alreadyUpdateEvents=false;
    		for(Event e:updateEvents){
    			if(li.entry.id == e.id) {alreadyUpdateEvents=true;}
    		}
    		for(Event currentE:currentEvents){
    			Boolean GoodToUpdateE = false;
    			Event e1 = new Event(id=li.entry.Event_Id__c);
    			if(alreadyUpdateEvents==false && currentE.id == li.entry.Event_Id__c){    			    				
    				if(currentE.StartDateTime != li.entry.Start_Time__c || currentE.EndDateTime != li.entry.End_Time__c){ 
    					e1.StartDateTime=li.entry.Start_Time__c; e1.EndDateTime=li.entry.End_Time__c; GoodToUpdateE=true;
    				}
    				if(currentE.Subject != li.entry.Name){ e1.Subject=li.entry.Name; GoodToUpdateE=true;}
    			}
    			if(GoodToUpdateE==true) {
    				Boolean alreadyUpdateEvents2=false;
    				for(Event e:updateEvents){
    					if(e.id==e1.id) alreadyUpdateEvents2=true;
    				}
    				if(alreadyUpdateEvents2==false) updateEvents.add(e1);
    			}
    		}
    	}
    	if(updateEvents.size()>0) update updateEvents;  updateEvents=new List<Event>(); System.debug('updateEvents:'+updateEvents.size());
    }
    
    List<Time_Entry2__c> deleteentries{get{if(deleteentries==null)deleteentries=new List<Time_Entry2__c>();return deleteentries;}set;}
    public PageReference DeleteEntries(){   
    	deleteentries = new List<Time_Entry2__c>();
    	//Get Entry and Events to Delete
    	for(EntryItem it:entries){
    		if(it.DelSelected==true) {
    			deleteentries.add(it.entry);
	    		Boolean AlreadyDeleteList=false;
	    		for(Event ev: deleteEvents){
	    			if(it.entry.Event_Id__c == ev.id ) alreadyDeleteList=true;
	    		}
	    		if(AlreadyDeleteList==false && it.entry.Event_Type__c=='Salesforce') {Event delE=new Event(id=it.entry.Event_Id__c); deleteEvents.add(delE);}
    		}
    	} 	
    	System.debug('deleteentries.size: '+deleteentries.size());	    	
    	if(deleteentries.size()>0) {
	    	delete deleteentries;   deleteentries=null;
	    	System.debug('deleteEvents.size:'+deleteEvents.size()); if(deleteEvents.size()>0) {delete deleteEvents;}  deleteEvents=null;
	    	PageReference pageRef = new PageReference('/apex/Time_Sheet_Manage?id='+theId);
			pageRef.setRedirect(true); 
			return pageRef;
    	} else {
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Selected Products to Delete');
			ApexPages.addMessage(myMsg);
    	} 
    	return null;	     
    }    
    public Id editlineId{get{return editlineId;} set{editlineId = value;}}	
    public Decimal LaborHours{
    	get{
    		LaborHours=0;
    		for(EntryItem ei: ItemEntries){
    			if(ei.entry.Hours__c>0 && ei.entry.Type__c=='Labor'){ 
    				LaborHours+= ei.entry.Hours__c;
    			}
    		}
    		return LaborHours;
    	}
    	set;	
    }
    public Decimal totalHours{
    	get{
    		totalHours=0;
    		for(EntryItem ei: ItemEntries){
    			if(ei.entry.Hours__c>0) totalHours+= ei.entry.Hours__c;
    		}
    		return totalHours;
    	}
    	set;	
    }
    
    
    public class NewEntryItem{
    	public Time_Entry2__c entry{get; set;}
    	public Boolean DelSelected {get{if(DelSelected==null)return false; return DelSelected;}set;}
    	public String StartMonth{get;set;}
    	public String StartDay{get;set;}
    	public String StartHour{get;set;}
    	public String StartMinute{get;set;}
    	public String StartYear{get;set;}
    	public String StartAMPM{get;set;}
    	public String EndMonth{get;set;}
    	public String EndDay{get;set;}
    	public String EndHour{get;set;}
    	public String EndMinute{get;set;}
    	public String EndYear{get;set;}
    	public String EndAMPM{get;set;}     	
    }
    public List<NewEntryItem> NewEntryItems{get{if(NewEntryItems==null)NewEntryItems=new List<NewEntryItem>();return NewEntryItems;} set;} // User created new entries
    public Integer newEntriesSize{get{if(newEntriesSize==null) newEntriesSize=0; return newEntriesSize;}set;}
    public void addEntriesSize(){
    	Time_Entry2__c newEntry = new Time_Entry2__c();
    	NewEntryItem ne = new NewEntryItem();
    	ne.entry = newEntry; ne.entry.TimeSheet__c = theId;
    	ne.DelSelected=false;
    	ne.StartMonth = System.now().month().format();
    	ne.StartDay = System.now().day().format();
    	ne.StartYear = System.now().year().format();    	
    	ne.StartMinute = '30';
    	ne.EndMonth = System.now().month().format();
    	ne.EndDay = System.now().day().format();
    	ne.EndYear = System.now().year().format();
    	ne.EndMinute = '30';
    	if(System.now().hour()>12){
	    	ne.EndHour = (System.now().hour()-12).format();  ne.StartAMPM = 'PM';
	    	ne.StartHour = (System.now().hour()-12).format();  ne.EndAMPM = 'PM';
    	} else if(System.now().hour()==12){
    		ne.StartHour = System.now().hour().format(); ne.StartAMPM = 'PM';
			ne.EndHour = System.now().hour().format();	  ne.EndAMPM = 'PM';
	    } else if(System.now().hour()==0){
	    	ne.StartHour = '12'; ne.EndAMPM = 'AM';
	   		ne.EndHour = '12';  ne.EndAMPM = 'AM';    	
	 	}else{
    		ne.EndHour = (System.now().hour()).format();  ne.EndAMPM = 'AM';
	    	ne.StartHour = (System.now().hour()).format();  ne.StartAMPM = 'AM';    	  
    	}
    	newEntryItems.add(ne);
    	newEntriesSize++;
    }
    public void updateNewDates(){
		for(NewEntryItem li:NewEntryItems){
			if(li.StartAMPM=='PM' && li.StartHour!='12') { li.StartHour=(integer.valueOf(li.StartHour)+12).format(); }
			if(li.StartAMPM=='AM' && li.StartHour=='12') { li.StartHour=(integer.valueOf(li.StartHour)-12).format(); }
			System.debug('li.StartHour: '+li.StartHour);
			li.entry.Start_Time__c = datetime.newInstance(integer.valueOf(li.StartYear.replace(',','')), integer.valueOf(li.StartMonth), integer.valueOf(li.StartDay), integer.valueOf(li.StartHour), integer.valueOf(li.StartMinute), 0);
			if(li.EndAMPM=='PM' && li.EndHour!='12') { li.EndHour=(integer.valueOf(li.EndHour)+12).format(); }
			if(li.EndAMPM=='AM' && li.EndHour=='12') { li.EndHour=(integer.valueOf(li.EndHour)-12).format(); }
			System.debug('li.EndHour: '+li.EndHour);
			li.entry.End_Time__c = datetime.newInstance(integer.valueOf(li.EndYear.replace(',','')), integer.valueOf(li.EndMonth), integer.valueOf(li.EndDay), integer.valueOf(li.EndHour), integer.valueOf(li.EndMinute), 0);			
		}
	}
    public PageReference SaveNewEntries(){
    	updateNewDates();
    	List<Time_Entry2__c> tentries = new List<Time_Entry2__c>();
    	for(NewEntryItem nei: NewEntryItems){
    		Time_Entry2__c te = nei.entry;
    		tentries.add(te);
    	}
    	insert tentries;
    	PageReference pageRef = new PageReference('/apex/Time_Sheet_Manage?id='+theId);
		pageRef.setRedirect(true); 			
		return pageRef;
    }
    public void DeleteNewEntries(){
    	Integer i=0; 
    	while (i<NewEntryItems.size()){
    		if(NewEntryItems[i].DelSelected==true){
    			NewEntryItems.remove(i);
    		} else {
    			i++;
    		}
    	}
    }
    
    //Utility
    public List<SelectOption> getYears(){
		List<SelectOption> options = new List<SelectOption>();
		String time1 = sheet.Start_Date__c.year().format().replace(',','');  options.add(new SelectOption(time1,time1));		
		String time2 = sheet.End_Date__c.year().format().replace(',','');  
		if(time1!=time2) options.add(new SelectOption(time2,time2));	
        return options;
	}
    public List<SelectOption> getMonths(){
		List<SelectOption> options = new List<SelectOption>();		
		for(Integer i=sheet.Start_Date__c.month(); i<=sheet.End_Date__c.month(); i++){
			options.add(new SelectOption(i.format(),i.format()));
		}
        return options;
	}
	public List<SelectOption> getDays(){
		List<SelectOption> options = new List<SelectOption>();
		for(Integer i=sheet.Start_Date__c.day(); i<=sheet.End_Date__c.day(); i++){
			options.add(new SelectOption(i.format(),i.format()));
		}
        return options;
	}
    public List<SelectOption> getHours(){
		List<SelectOption> options = new List<SelectOption>();
		for(Integer i=1; i<=12; i++){
			options.add(new SelectOption(i.format(),i.format()));
		}
        return options;
	}
	public List<SelectOption> getMinutes(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('0',':00'));
		options.add(new SelectOption('5',':05'));
		options.add(new SelectOption('10',':10'));
		options.add(new SelectOption('15',':15'));
		options.add(new SelectOption('20',':20'));
		options.add(new SelectOption('25',':25'));
		options.add(new SelectOption('30',':30'));
		options.add(new SelectOption('35',':35'));
		options.add(new SelectOption('40',':40'));
		options.add(new SelectOption('45',':45'));
		options.add(new SelectOption('50',':50'));
		options.add(new SelectOption('55',':55'));
		options.add(new SelectOption('60',':60'));
		return options;
	}
	public List<SelectOption> getAMPM(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('AM','AM'));
		options.add(new SelectOption('PM','PM'));
        return options;
	}
	
       
}