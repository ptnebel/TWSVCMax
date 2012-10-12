public class SVMX_DrawTechRoute {
    String SelDt=System.currentPageReference().getParameters().get('dt');
    String TechId=System.currentPageReference().getParameters().get('tec');
    String SrvTeamId=System.currentPageReference().getParameters().get('st');
    String xMapStr='',key,StrHomeLL='';
    set<Id> WOIds=new set<Id>();
    set<Id> TechIds=new set<Id>();
    set<Id> TechUsrIds=new set<Id>();
     set<Id> EvtTechIds=new set<Id>();
    List<SVMXC__Service_Order__c> UnagnWO= new List<SVMXC__Service_Order__c>();
     
     public SVMX_DrawTechRoute(){
        /*SVMXC.COMM_Utils_ManageSettings settings = new SVMXC.COMM_Utils_ManageSettings();
        Map<String, String> mySettings = settings.SVMX_getSettingList('CUSTSUB002','CUSTSET001');
        key= mySettings.get('CUSTSET001');
        System.debug('key:'+key);*/
        
        System.debug('SelDt'+SelDt);
        System.debug('TechId'+TechId);
        System.debug('SrvTeamId'+SrvTeamId);
        TechIds.clear();
        xMapStr='';
        date Scheduledate=system.now().dateGmt();
        datetime StScheduledate=system.now();
        datetime EdScheduledate=system.now();

        if(SrvTeamId != 'null' && SrvTeamId != '' && SrvTeamId != null && (TechId == 'null' || TechId =='' || TechId == null)){
            System.debug('service Team  in');
            List<SVMXC__Service_Group_Members__c> alltechs = [select id,Home_Latitude__c, Home_Longitude__c, SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__Service_Group__c,SVMXC__Phone__c,Name,SVMXC__Service_Group__r.Name,SVMXC__Street__c,SVMXC__City__c,SVMXC__Zip__c,SVMXC__State__c,SVMXC__Country__c,SVMXC__Salesforce_User__c from SVMXC__Service_Group_Members__c where SVMXC__Service_Group__c=:SrvTeamId];
            for(SVMXC__Service_Group_Members__c GPM:alltechs){
                if(GPM.SVMXC__Salesforce_User__c != null)
                    TechUsrIds.add(GPM.SVMXC__Salesforce_User__c);
                else                    
                    TechIds.add(GPM.id);
                StrHomeLL=StrHomeLL+GPM.Home_Latitude__c+':'+GPM.Home_Longitude__c+':'+GPM.id+':'+GPM.SVMXC__Service_Group__c+':'+GPM.SVMXC__Phone__c+':'+GPM.Name+':'+GPM.SVMXC__Service_Group__r.Name+':'+GPM.SVMXC__Street__c+':'+GPM.SVMXC__City__c+':'+GPM.SVMXC__State__c+':'+GPM.SVMXC__Zip__c+'~:~';
            }
            
        }else if(TechId != 'null' && TechId !='' && TechId != null){
            System.debug('Tech in'+TechId);
            TechIds.add(TechId);            
            SVMXC__Service_Group_Members__c Seltch=[select id,Home_Latitude__c, Home_Longitude__c, SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__Service_Group__c,SVMXC__Phone__c,Name,SVMXC__Service_Group__r.Name,SVMXC__Street__c,SVMXC__City__c,SVMXC__Zip__c,SVMXC__State__c,SVMXC__Country__c,SVMXC__Salesforce_User__c from SVMXC__Service_Group_Members__c where id =:TechId];
            
            TechUsrIds.add(Seltch.SVMXC__Salesforce_User__c);
            
            StrHomeLL=StrHomeLL+Seltch.Home_Latitude__c+':'+Seltch.Home_Longitude__c+':'+Seltch.id+':'+Seltch.SVMXC__Service_Group__c+':'+Seltch.SVMXC__Phone__c+':'+Seltch.Name+':'+Seltch.SVMXC__Service_Group__r.Name+':'+Seltch.SVMXC__Street__c+':'+Seltch.SVMXC__City__c+':'+Seltch.SVMXC__State__c+':'+Seltch.SVMXC__Zip__c+'~:~';
            
        }
        if(SelDt != 'null' && SelDt !='' && SelDt != null){
            String yr=SelDt.substring(0, 4);
            String mn=SelDt.substring(4, 6);
            String dt=SelDt.substring(6, 8);
            Scheduledate=date.newInstance(integer.valueof(yr), integer.valueof(mn), integer.valueof(dt));
            StScheduledate=datetime.newInstance(integer.valueof(yr), integer.valueof(mn), integer.valueof(dt),00,00,00);
            EdScheduledate=datetime.newInstance(integer.valueof(yr), integer.valueof(mn), integer.valueof(dt),23,59,59);
        }
        if(StrHomeLL != ''){
            xMapStr=StrHomeLL+'~:::::~';
        }
        if(StScheduledate != NULL && EdScheduledate != NULL){
                
                UnagnWO=[select id,Name,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__Preferred_Start_Time__c,SVMXC__Street__c,Address_2__c,SVMXC__City__c,SVMXC__Zip__c,SVMXC__Scheduled_Date_Time__c,SVMXC__State__c,SVMXC__Country__c,SVMXC__Dispatch_Status__c,SVMXC__Special_Instructions__c,SVMXC__Work_Performed__c
                        from SVMXC__Service_Order__c where SVMXC__Dispatch_Status__c='New' 
                            and SVMXC__Scheduled_Date_Time__c >:StScheduledate and SVMXC__Scheduled_Date_Time__c <:EdScheduledate];
            if(UnagnWO != null && UnagnWO.size()>0){
                for(SVMXC__Service_Order__c Unasswo:UnagnWO){
                    String StrPref=String.valueOf(Unasswo.SVMXC__Preferred_Start_Time__c);
                    String StrWrkPrfmd=String.valueOf(Unasswo.SVMXC__Work_Performed__c);
                    String StrSchDate=String.valueOf(Unasswo.SVMXC__Scheduled_Date_Time__c);
                    String StrSplinst=String.valueOf(Unasswo.SVMXC__Special_Instructions__c);
                    if(StrPref != null)
                        StrPref=StrPref.replaceAll(':', ';');                     
                    if(StrWrkPrfmd != null)
                        StrWrkPrfmd=StrWrkPrfmd.replaceAll(':', ';'); 
                    if(StrSchDate != null)
                        StrSchDate=StrSchDate.replaceAll(':', ';');  
                    if(StrSplinst != null)
                        StrSplinst=StrSplinst.replaceAll(':', ';');           
                    xMapStr=xMapStr+'O:'+Unasswo.SVMXC__Latitude__c+':'+Unasswo.SVMXC__Longitude__c+':'+
                            Unasswo.Id+':'+Unasswo.Name+':'+
                            StrPref+':'+Unasswo.SVMXC__Street__c+':'+Unasswo.SVMXC__City__c+':'+
                            Unasswo.SVMXC__Zip__c+':'+StrWrkPrfmd+':'+StrSchDate+':'+StrSplinst+'~:~';
                
                }
                xMapStr=xMapStr+'~::::~';
                if(xMapStr != null)
                    xMapStr=String.valueOf(xMapStr).replaceAll('\'', '`');
            }
            
         }
         System.debug(UnagnWO.size());
        if(TechIds != null && TechIds.size()>0 || TechUsrIds != null && TechUsrIds.size()>0){
            List<SVMXC__SVMX_Event__c> xEvtTech=[select Id,SVMXC__ActivityDate__c,SVMXC__StartDateTime__c,
                                        SVMXC__Technician__c,SVMXC__Technician__r.SVMXC__Latitude__c,SVMXC__Technician__r.SVMXC__Longitude__c,SVMXC__Technician__r.Name,
                                        SVMXC__Technician__r.SVMXC__Street__c,SVMXC__Technician__r.SVMXC__City__c,SVMXC__Technician__r.SVMXC__State__c,
                                        SVMXC__Technician__r.SVMXC__Country__c,SVMXC__Technician__r.SVMXC__Zip__c,
                                        SVMXC__Technician__r.SVMXC__Phone__c,SVMXC__Technician__r.SVMXC__Service_Group__c,
                                        SVMXC__Technician__r.SVMXC__Service_Group__r.Name,SVMXC__WhatId__c 
                                        from SVMXC__SVMX_Event__c where SVMXC__Technician__c in:TechIds and SVMXC__ActivityDate__c=:Scheduledate order by SVMXC__StartDateTime__c ];
            for(SVMXC__SVMX_Event__c evt:xEvtTech){
                WOIds.add(evt.SVMXC__WhatId__c);
            }
            map<id,SVMXC__Service_Order__c> mapWOEvt= new map<id,SVMXC__Service_Order__c>([select id,Name,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__Preferred_Start_Time__c,SVMXC__Street__c,Address_2__c,SVMXC__City__c,SVMXC__Zip__c,SVMXC__Scheduled_Date_Time__c,SVMXC__State__c,SVMXC__Country__c,SVMXC__Dispatch_Status__c,SVMXC__Special_Instructions__c,SVMXC__Work_Performed__c from SVMXC__Service_Order__c where id in:WOIds]);           

             List<Event> xSFEvtTech=[select Id,ActivityDate,ActivityDateTime,OwnerId,WhatId from Event where OwnerId in:TechUsrIds and ActivityDate=:Scheduledate order by ActivityDateTime];
             
             WOIds.clear();
             for(Event SFevt:xSFEvtTech){
                EvtTechIds.add(SFevt.OwnerId);
                WOIds.add(SFevt.WhatId);
            }
            
             List<SVMXC__Service_Group_Members__c> xSFTech=[select id,Name,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__Phone__c,SVMXC__Street__c,SVMXC__City__c,SVMXC__Zip__c,SVMXC__Service_Group__c,SVMXC__State__c,SVMXC__Country__c,SVMXC__Service_Group__r.Name,SVMXC__Salesforce_User__c from SVMXC__Service_Group_Members__c where SVMXC__Salesforce_User__c in:EvtTechIds];
             
             map<id,SVMXC__Service_Group_Members__c> mapTechEvt= new map<id,SVMXC__Service_Group_Members__c>(); 
             for(SVMXC__Service_Group_Members__c tech:xSFTech){
                mapTechEvt.put(tech.SVMXC__Salesforce_User__c,tech);
             }
             System.debug('mapTechEvt'+mapTechEvt);
             
             map<id,SVMXC__Service_Order__c> mapWOSFEvt= new map<id,SVMXC__Service_Order__c>([select id,Name,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__Preferred_Start_Time__c,SVMXC__Street__c,Address_2__c,SVMXC__City__c,SVMXC__Zip__c,SVMXC__Scheduled_Date_Time__c,SVMXC__State__c,SVMXC__Country__c,SVMXC__Dispatch_Status__c,SVMXC__Special_Instructions__c,SVMXC__Work_Performed__c from SVMXC__Service_Order__c where id in:WOIds]);  
             
            if(UnagnWO.size()==0 && (xEvtTech != null && xEvtTech.size()>0 || xSFEvtTech!= null && xSFEvtTech.size()>0))
                xMapStr=xMapStr+'~::::~';
            
            for(SVMXC__SVMX_Event__c EvtTech:xEvtTech){
				if(TechIds.contains(EvtTech.SVMXC__Technician__c)){
					xMapStr=xMapStr+EvtTech.SVMXC__Technician__r.SVMXC__Latitude__c+':'+EvtTech.SVMXC__Technician__r.SVMXC__Longitude__c+':'+EvtTech.SVMXC__Technician__c+':'+EvtTech.SVMXC__Technician__r.SVMXC__Service_Group__c+':'+EvtTech.SVMXC__Technician__r.SVMXC__Phone__c+':'+EvtTech.SVMXC__Technician__r.Name+':'+EvtTech.SVMXC__Technician__r.SVMXC__Service_Group__r.Name+':'+EvtTech.SVMXC__Technician__r.SVMXC__Street__c+':'+EvtTech.SVMXC__Technician__r.SVMXC__City__c+':'+EvtTech.SVMXC__Technician__r.SVMXC__State__c+':'+EvtTech.SVMXC__Technician__r.SVMXC__Zip__c+'~::~';
					for(SVMXC__SVMX_Event__c EvtTech1:xEvtTech){
						if(mapWOEvt.containskey(EvtTech1.SVMXC__WhatId__c) && EvtTech.SVMXC__Technician__c==EvtTech1.SVMXC__Technician__c){
							String StrPref=String.valueOf(mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Preferred_Start_Time__c);
							String StrWrkPrfmd=String.valueOf(mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Work_Performed__c);
							String StrSchDate=String.valueOf(mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Scheduled_Date_Time__c);
							String StrSplinst=String.valueOf(mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Special_Instructions__c);
							if(StrPref != null)
								StrPref=StrPref.replaceAll(':', ';');                   
							if(StrWrkPrfmd != null)
								StrWrkPrfmd=StrWrkPrfmd.replaceAll(':', ';');
							if(StrSchDate != null)
								StrSchDate=StrSchDate.replaceAll(':', ';');  
							if(StrSplinst != null)
								StrSplinst=StrSplinst.replaceAll(':', ';');
							xMapStr=xMapStr+'O:'+mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Latitude__c+':'+mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Longitude__c+':'+
									mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).Id+':'+mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).Name+':'+                          
									StrPref+':'+mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Street__c+':'+mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__City__c+':'+
									mapWOEvt.get(EvtTech1.SVMXC__WhatId__c).SVMXC__Zip__c+':'+
									StrWrkPrfmd+':'+StrSchDate+':'+StrSplinst+'~:~';
						}
					}
					xMapStr=xMapStr+'~:::~';
					TechIds.remove(EvtTech.SVMXC__Technician__c);
				}
            }
            for(Event EvtTech:xSFEvtTech){
                if(mapTechEvt.containskey(EvtTech.OwnerId) && TechUsrIds.contains(EvtTech.OwnerId)){
                    xMapStr=xMapStr+mapTechEvt.get(EvtTech.OwnerId).SVMXC__Latitude__c+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__Longitude__c+':'+mapTechEvt.get(EvtTech.OwnerId).Id+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__Service_Group__c+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__Phone__c+':'+mapTechEvt.get(EvtTech.OwnerId).Name+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__Service_Group__r.Name+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__Street__c+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__City__c+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__State__c+':'+mapTechEvt.get(EvtTech.OwnerId).SVMXC__Zip__c+'~::~';
					for(Event EvtTech1:xSFEvtTech){
						if(mapWOSFEvt.containskey(EvtTech1.WhatId) && EvtTech.OwnerId ==EvtTech1.OwnerId){
							String StrPref=String.valueOf(mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Preferred_Start_Time__c);
							String StrWrkPrfmd=String.valueOf(mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Work_Performed__c);
							String StrSchDate=String.valueOf(mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Scheduled_Date_Time__c);
							String StrSplinst=String.valueOf(mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Special_Instructions__c);
							if(StrPref != null)
								StrPref=StrPref.replaceAll(':', ';');                   
							if(StrWrkPrfmd != null)
								StrWrkPrfmd=StrWrkPrfmd.replaceAll(':', ';');
							if(StrSchDate != null)
								StrSchDate=StrSchDate.replaceAll(':', ';');  
							if(StrSplinst != null)
								StrSplinst=StrSplinst.replaceAll(':', ';');
							xMapStr=xMapStr+'O:'+mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Latitude__c+':'+mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Longitude__c+':'+
									mapWOSFEvt.get(EvtTech1.WhatId).Id+':'+mapWOSFEvt.get(EvtTech1.WhatId).Name+':'+                          
									StrPref+':'+mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Street__c+':'+mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__City__c+':'+
									mapWOSFEvt.get(EvtTech1.WhatId).SVMXC__Zip__c+':'+
									StrWrkPrfmd+':'+StrSchDate+':'+StrSplinst+'~:~';
						}
					}					
                    xMapStr=xMapStr+'~:::~';
					TechUsrIds.remove(EvtTech.OwnerId);
                }
            }
            if(xMapStr != null)
                xMapStr=String.valueOf(xMapStr).replaceAll('\'', '`');
        }

    }
    public PageReference Redrt(){
        PageReference thirdPage = new PageReference('/apex/SVMX_DrawUSRmap');
        thirdPage.setRedirect(true); 
        return thirdPage;
    }
    public string getMapStr(){
        return xMapStr;
    }
    public string getmyKey(){
        String key='ABQIAAAASeLn86_eKPE1zeDspxFbFxQdMY-rqcBK7mOLf4exckLw5w98-BSbrnMwn2CB7tQFrtb6vBKGwd396Q';
        return key;
    }
    
    
    /******************************************************* Unit Test *********************************************************/
    static testMethod void SVMX_DrawTechRoute_UT() {
               
        SVMXC__Service_Group__c ST= new SVMXC__Service_Group__c(Name='TstSrvTeam',
                                                                SVMXC__Active__c=true,
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                SVMXC__Country__c='United States',
                                                                SVMXC__Zip__c='29910'                                                               
                                                                );
        insert ST;
        
        SVMXC__Service_Group_Members__c Tech= new SVMXC__Service_Group_Members__c(Name='TstTech',
                                                                SVMXC__Active__c=true,
                                                                SVMXC__Service_Group__c=ST.Id,
                                                                SVMXC__Phone__c='330-518-4973',
                                                                SVMXC__Enable_Scheduling__c=true,
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                SVMXC__Zip__c='29910'
                                                                );
        insert Tech;
        SVMXC__Service_Order__c WO1= new SVMXC__Service_Order__c(SVMXC__Work_Performed__c='test',
                                                                SVMXC__Scheduled_Date_Time__c=system.now(),
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                //SVMXC__Dispatch_Status__c='New',
                                                                SVMXC__Zip__c='29910'
                                                                );
        insert WO1;
        
        SVMXC__Service_Order__c WO= new SVMXC__Service_Order__c(SVMXC__Scheduled_Date_Time__c=system.now(),
                                                                SVMXC__Work_Performed__c='test',
                                                                SVMXC__Service_Group__c=ST.Id,                                                              
                                                                SVMXC__Group_Member__c=Tech.id,
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                SVMXC__Zip__c='29910'
                                                                );
        insert WO;
        
        SVMXC__SVMX_Event__c SVMXEvt = new SVMXC__SVMX_Event__c(Name='WO-00001010',
                                                                SVMXC__Technician__c=Tech.Id,
                                                                SVMXC__WhatId__c=WO.Id,
                                                                SVMXC__StartDateTime__c=system.now(),
                                                                SVMXC__EndDateTime__c=system.now().addMinutes(120),
                                                                SVMXC__ActivityDateTime__c=system.now(),
                                                                SVMXC__ActivityDate__c=system.now().date(),
                                                                SVMXC__DurationInMinutes__c=120
                                                                );
        insert SVMXEvt;
        
        
        String yr=String.valueOf(system.now().year());
        String mn=String.valueOf(system.now().month());
        if(mn.length()<2)
            mn='0'+mn;
        String dte=String.valueOf(system.now().day());
        if(dte.length()<2)
            dte='0'+dte;
        
        //Test converage for the visualforce page
        PageReference pageRef = Page.SVMX_DrawTechRoute;        
        pageRef.getParameters().put('dt',String.valueof(yr+mn+dte));
        pageRef.getParameters().put('tec',Tech.Id);
        pageRef.getParameters().put('st',ST.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_DrawTechRoute thisPageCon = new SVMX_DrawTechRoute();
       String temp;
       temp = thisPageCon.getMapStr();
       temp = thisPageCon.getmyKey();
       
       PageReference tempPR = thisPageCon.Redrt();
       
       //Test converage for the visualforce page
        PageReference pageRef1 = Page.SVMX_WOLatLng;        
        pageRef1.getParameters().put('dt',String.valueof(yr+mn+dte));
        pageRef1.getParameters().put('tec','');
        pageRef1.getParameters().put('st',ST.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // create an instance of the controller
        SVMX_DrawTechRoute thisPageCon1 = new SVMX_DrawTechRoute();
    }
}