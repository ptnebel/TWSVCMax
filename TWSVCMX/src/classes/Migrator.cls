global class Migrator {	
	public String endpt1{get;set;}	// 1 is the origin org	
	public String endpt2{get;set;}  // 2 is the destination org
	public List<SelectOption> getEnvironmentType(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('Production','Production'));
		options.add(new SelectOption('Sandbox','Sandbox'));
        return options;
	}
	public String SourceUserName{get;set;}	
	public String SourcePassword{get;set;}
	public String SourceURL{get;set;}
	//public String DestinationUserName{get;set;}
	//public String DestinationPassword{get;set;}	
	//public String DestinationURL{get;set;}
	public String body1{get;set;} public String body2{get;set;} public String body3{get;set;} public String body4{get;set;} public String body5{get;set;} public String body6{get;set;}
	
	public List<Account> acc1{get;set;}
	public List<Account> acc2{get;set;}
	public Integer getAcc1Size(){if(acc1!=null){return acc1.size();} else return -1;}
	public Integer getAcc2Size(){if(acc2!=null){return acc2.size();} else return -1;}
	public List<SVMXC__ServiceMax_Processes__c> smprocesses{get{if(smprocesses==null)getSessionId1(); return smprocesses;}set;}
	public List<SVMXC__ServiceMax_Config_Data__c> configdata{get;set;}
	public List<SVMXC__Page_Layout__c> pagelayouts{get;set;}
	public List<SVMXC__Page_Layout_Detail__c> pagelayoutdetails{get;set;}
	public List<SVMXC__SFM_Event__c> sfmevents{get;set;}	
	
	public String SessionId1;
	public String getSessionId1(){				
		if(SourceUserName!=null && SourcePassword!=null ){		
	    	try{
		    	HttpRequest request = new HttpRequest();
		    	if(endpt1=='Production' || endpt1=='' || endpt1==null){
					request.setEndpoint('https://www.salesforce.com/services/Soap/u/22.0');     // set from VF Page
				} else if (endpt1=='Sandbox'){
					request.setEndpoint('https://test.salesforce.com/services/Soap/u/22.0');     // set from VF Page
				}			
				request.setMethod('POST');
				request.setHeader('Content-type','text/xml;charset=UTF-8');
				request.setHeader('SOAPAction', '""');
				request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + SourceUserName+ '</username><password>' + SourcePassword+ '</password></login></Body></Envelope>');
        		Dom.XmlNode resultElmt = (new Http()).send(request).getBodyDocument().getRootElement().getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('loginResponse', 'urn:partner.soap.sforce.com').getChildElement('result', 'urn:partner.soap.sforce.com');
        		SourceURL = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com').getText().split('/services')[0];
        		SessionId1 = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com').getText();
				
				System.debug('SessionId1 debug: '+SessionId1);
		   /*     
		        //Accounts			        
		        PageReference theUrl = new PageReference(SourceURL +'/services/data/v22.0/query/');
		        System.debug('theURL.getURL: '+theUrl.getUrl());
		        theUrl.getParameters().put('q','Select Id, Phone, Name, CreatedBy.FirstName, CreatedById From Account ORDER BY Name limit 10');			        
		        request = new HttpRequest();
		        request.setEndpoint(theUrl.getUrl());
		        request.setMethod('GET');
		        request.setHeader('Authorization', 'OAuth ' + SessionId1);
		 		body1 = (new Http()).send(request).getBody();
		 		System.debug('body1 Account DEBUG : '+body1);
		        JSONParser parser = JSON.createParser(body1);			 
		        do{
		            parser.nextToken();
		        }while(parser.hasCurrentToken() && !'records'.equals(parser.getCurrentName()));			 
		        parser.nextToken();			 
		        acc1 = (List<Account>) parser.readValueAs(List<Account>.class);
		   */     
		        //ServiceMax Processes
		        PageReference theUrl = new PageReference(SourceURL +'/services/data/v22.0/query/');
		        System.debug('theURL.getURL: '+theUrl.getUrl());
		        theUrl.getParameters().put('q','Select Id, RecordTypeId, RecordType.Name, SVMXC__MAPID__C, SVMXC__SOURCE_OBJECT_NAME__C, SVMXC__TARGET_OBJECT_NAME__C, SVMXC__Name__c, SVMXC__DESCRIPTION__C, SVMXC__ACTIVE__C, SVMXC__IsStandard__c From SVMXC__ServiceMax_Processes__c ORDER BY RecordTypeId ');			        
		        request = new HttpRequest();
		        request.setEndpoint(theUrl.getUrl());
		        request.setMethod('GET');
		        request.setHeader('Authorization', 'OAuth ' + SessionId1);
		        body2 = (new Http()).send(request).getBody();
		        System.debug('body2 ServiceMax Processes DEBUG : '+body2);
		        JSONParser ProcessesParser = JSON.createParser(body2);			 
		        do{
		            ProcessesParser.nextToken();
		        }while(ProcessesParser.hasCurrentToken() && !'records'.equals(ProcessesParser.getCurrentName()));			 
		        ProcessesParser.nextToken();			 
		        smprocesses = (List<SVMXC__ServiceMax_Processes__c>) ProcessesParser.readValueAs(List<SVMXC__ServiceMax_Processes__c>.class);
		        System.debug('smprocesses size in getSessionId: '+smprocesses.size());
		        
		        //Config Data
		        theUrl = new PageReference(SourceURL +'/services/data/v22.0/query/');
		        System.debug('theURL.getURL: '+theUrl.getUrl());
		        theUrl.getParameters().put('q','Select Id, SVMXC__Expression_Type__c, SVMXC__Expression_Rule__c, SVMXC_Expression_Type__c, SVMXC__Sequence__c, SVMXC__Object_Name__c, SVMXC_Field_Name__c, SVMXC__Operator__c, SVMXC__Operand__c From SVMXC__ServiceMax_Config_Data__c ');			        
		        request = new HttpRequest();
		        request.setEndpoint(theUrl.getUrl());
		        request.setMethod('GET');
		        request.setHeader('Authorization', 'OAuth ' + SessionId1);
		        body3 = (new Http()).send(request).getBody();
		        System.debug('body3 Config Data DEBUG : '+body3);
		        JSONParser ConfigParser = JSON.createParser(body3);			 
		        do{
		            ConfigParser.nextToken();
		        }while(ConfigParser.hasCurrentToken() && !'records'.equals(ConfigParser.getCurrentName()));			 
		        ConfigParser.nextToken();			 
		        configdata = (List<SVMXC__ServiceMax_Config_Data__c>) ConfigParser.readValueAs(List<SVMXC__ServiceMax_Config_Data__c>.class);
		  /*      
		        //PageLayout
		        theUrl = new PageReference(SourceURL +'/services/data/v22.0/query/');
		        System.debug('theURL.getURL: '+theUrl.getUrl());
		        theUrl.getParameters().put('q','Select Id, SVMXC__Page_Layout_ID__c, Name, SVMXC__Object_Name__c, SVMXC__Type__c, SVMXC__IsStandard__c, SVMXC__Page_Help__c, SVMXC__Help_URL__c, SVMXC__ENABLE_ATTACHMENTS__C, SVMXC__ENABLE_CHATTER__C, SVMXC__PROMPT_FOR_NEW_EVENT__C, SVMXC__SHOW_ACCOUNT_HISTORY__C, SVMXC__SHOW_ALL_SECTIONS_BY_DEFAULT__C, SVMXC__SHOW_PRODUCT_HISTORY__C, SVMXC__Enable_Troubleshooting__c, SVMXC__Enable_Service_Report_View__c, SVMXC__Enable_Service_Report_Generation__c From SVMXC__Page_Layout__c ');			        
		        request = new HttpRequest();
		        request.setEndpoint(theUrl.getUrl());
		        request.setMethod('GET');
		        request.setHeader('Authorization', 'OAuth ' + SessionId1);
		        body4 = (new Http()).send(request).getBody();
		        System.debug('body4 PageLayout DEBUG : '+body4);
		        JSONParser PageParser = JSON.createParser(body4);			 
		        do{
		            PageParser.nextToken();
		        }while(PageParser.hasCurrentToken() && !'records'.equals(PageParser.getCurrentName()));			 
		        PageParser.nextToken();			 
		        pagelayouts = (List<SVMXC__Page_Layout__c>) PageParser.readValueAs(List<SVMXC__Page_Layout__c>.class);
		        
		        
		        //PageLayout Details
		        theUrl = new PageReference(SourceURL +'/services/data/v22.0/query/');
		        System.debug('theURL.getURL: '+theUrl.getUrl());
		        theUrl.getParameters().put('q','Select Id, SVMXC__Page_Layout_ID__c, SVMXC__Header_Page_Layout__c, Name, SVMXC__Object_Name__c, SVMXC__Header_Reference_Field__c, SVMXC__Help_URL__c,	SVMXC__Page_Help__c, SVMXC__Type__c,	SVMXC__IsStandard__c, SVMXC__Allow_New_Lines__c, SVMXC__Allow_Delete_Lines__c, SVMXC__Allow_zero_lines__c,	SVMXC__Sequence__c, SVMXC__Multi_Add_Search_Object__c, SVMXC__Multi_Add_Search_Field__c, SVMXC__Multi_Add_Configuration__c From SVMXC__Page_Layout_Detail__c ');			        
		        request = new HttpRequest();
		        request.setEndpoint(theUrl.getUrl());
		        request.setMethod('GET');
		        request.setHeader('Authorization', 'OAuth ' + SessionId1);
		        body5 = (new Http()).send(request).getBody();
		        System.debug('body5 PageLayout DEBUG : '+body5);
		        JSONParser PageLayoutParser = JSON.createParser(body5);			 
		        do{
		            PageLayoutParser.nextToken();
		        }while(PageLayoutParser.hasCurrentToken() && !'records'.equals(PageLayoutParser.getCurrentName()));			 
		        PageLayoutParser.nextToken();			 
		        pagelayoutdetails = (List<SVMXC__Page_Layout_Detail__c>) PageLayoutParser.readValueAs(List<SVMXC__Page_Layout_Detail__c>.class);
		        
		        //SFM Events
		        theUrl = new PageReference(SourceURL +'/services/data/v22.0/query/');
		        System.debug('theURL.getURL: '+theUrl.getUrl());
		        theUrl.getParameters().put('q','Select Id, SVMXC__Event_Id__c, SVMXC__Event_Type__c, SVMXC__Page_Layout__c, SVMXC__Page_Layout_Detail__c, SVMXC__IsStandard__c, SVMXC__Event_Call_Type__c, SVMXC__Target_Call__c From SVMXC__SFM_Event__c ');			        
		        request = new HttpRequest();
		        request.setEndpoint(theUrl.getUrl());
		        request.setMethod('GET');
		        request.setHeader('Authorization', 'OAuth ' + SessionId1);
		        body6 = (new Http()).send(request).getBody();
		        System.debug('body6 SFM Events DEBUG : '+body6);
		        JSONParser EventParser = JSON.createParser(body6);			 
		        do{
		            EventParser.nextToken();
		        }while(EventParser.hasCurrentToken() && !'records'.equals(EventParser.getCurrentName()));			 
		        EventParser.nextToken();			 
		        sfmevents = (List<SVMXC__SFM_Event__c>) EventParser.readValueAs(List<SVMXC__SFM_Event__c>.class);
		    */    
		        
	    	} catch(Exception e){		           
	        }		
		}	
		return SessionId1;		
	}
		
	public List<SVMXC__ServiceMax_Processes__c> smprocesses2{get;set;}
	public List<SVMXC__ServiceMax_Config_Data__c> configdata2{get;set;}
	public List<SVMXC__Page_Layout__c> pagelayouts2{get;set;}
	public List<SVMXC__Page_Layout_Detail__c> pagelayoutdetails2{get;set;}
	public List<SVMXC__SFM_Event__c> sfmevents2{get;set;}
	
	public void getDestinationData(){
		
	}
	public PageReference verifySession1(){
		try{
			getSessionId1();
			getDestinationData();
		} catch (System.Exception e){
			
		}
		return null;
	}
	
	global class OrganizedData{
		public Boolean OSelected{get;set;}
		public SVMXC__ServiceMax_Processes__c sourceprocess{get;set;}
		public SVMXC__ServiceMax_Config_Data__c configdata{get;set;}
		public SVMXC__Page_Layout__c pagelayout{get;set;}
		public SVMXC__Page_Layout_Detail__c pagelayoutdetail{get;set;}
		public SVMXC__SFM_Event__c sfmevent{get;set;}
	}
	public List<OrganizedData> odata = new List<OrganizedData>();
	public List<OrganizedData> getodata(){
		System.debug('smprocesses size in getodata: '+smprocesses.size());
		List<OrganizedData> orgdata = new List<OrganizedData>();
		return orgdata;
	}
	/*
	public List<OrganizedData> odata{ 
		get{
			//if(smprocesses==null){smprocesses=new List<SVMXC__ServiceMax_Processes__c>();}			
			List<OrganizedData> orgdata = new List<OrganizedData>();
			
			
			//System.debug('smprocesses size: '+smprocesses.size());			
			
			//for(SVMXC__ServiceMax_Processes__c p:smprocesses){
			//	OrganizedData od = new OrganizedData();
			//	od.OSelected = false;				
			//	od.sourceprocess = p;
			//	orgdata.add(od);
			//}
			
			return orgdata;
			
		}
	}
	*/
	
	/*
	public String SessionId2;
	public String getSessionId2(){				
		if(DestinationUserName!=null && DestinationPassword!=null ){		
	    	try{
		    	HttpRequest request = new HttpRequest();
		    	if(endpt2=='Production' || endpt2=='' || endpt2==null){
					request.setEndpoint('https://www.salesforce.com/services/Soap/u/22.0');     // set from VF Page
				} else if (endpt2=='Sandbox'){
					request.setEndpoint('https://test.salesforce.com/services/Soap/u/22.0');     // set from VF Page
				}			
				request.setMethod('POST');
				request.setHeader('Content-type','text/xml;charset=UTF-8');
				request.setHeader('SOAPAction', '""');
				request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + DestinationUserName+ '</username><password>' + DestinationPassword+ '</password></login></Body></Envelope>');
        		Dom.XmlNode resultElmt = (new Http()).send(request).getBodyDocument().getRootElement().getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('loginResponse', 'urn:partner.soap.sforce.com').getChildElement('result', 'urn:partner.soap.sforce.com');
        		DestinationURL = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com').getText().split('/services')[0];
        		SessionId2 = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com').getText();
				
				System.debug('SessionId2 debug: '+SessionId2);
		        			        
		        PageReference theUrl = new PageReference(DestinationURL +'/services/data/v22.0/query/');
		        System.debug('theURL.getURL: '+theUrl.getUrl());
		        theUrl.getParameters().put('q','Select Id, Phone, Name, CreatedBy.FirstName, CreatedById From Account ORDER BY Name limit 10');			        
		        request = new HttpRequest();
		        request.setEndpoint(theUrl.getUrl());
		        request.setMethod('GET');
		        request.setHeader('Authorization', 'OAuth ' + SessionId2);
		 		System.debug('DEBUG - before body: ');
		        String body = (new Http()).send(request).getBody();
		        System.debug('DEBUG - after body: ');
		 		System.debug('DEBUG - body: '+body);
		 		body2 = (new Http()).send(request).getBody();
		 		System.debug('body2 DEBUG : '+body2);
		        JSONParser parser = JSON.createParser(body);			 
		        do{
		            parser.nextToken();
		        }while(parser.hasCurrentToken() && !'records'.equals(parser.getCurrentName()));			 
		        parser.nextToken();			 
		        acc2 = (List<Account>) parser.readValueAs(List<Account>.class);
	    	} catch(Exception e){		           
	        }		
		}	
		return SessionId2;
		
	}
	public PageReference verifySession2(){
		try{
			getSessionId2();
		} catch (System.Exception e){
			
		}
		return null;
	}
	*/
	
	public void SaveDestinationAccounts(){
		List<Account> updateAccts = new List<Account>();
		for(Account a:acc2){
			for(Account a1:acc1){
				if(a.Name=='Acme2'&& a1.Name=='Acme2'){ 
					System.debug('old a: '+ a.Phone +' new a: '+a1.Phone);
					a.Phone=a1.Phone; 										
				}
			}
		}	
	}
	
}