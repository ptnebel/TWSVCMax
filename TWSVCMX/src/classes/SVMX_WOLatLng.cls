public class SVMX_WOLatLng {
    String SelDt=System.currentPageReference().getParameters().get('dt');
    String TechId=System.currentPageReference().getParameters().get('tec');
    String SrvTeamId=System.currentPageReference().getParameters().get('st');
    List<String> nextbat =new List<String>();
    List<String> WOIDs =new List<String>();
    set<Id> WOLLIds=new set<Id>();
    List<SVMXC__Service_Order__c> SelWO= new List<SVMXC__Service_Order__c>();
    List<SVMXC__SVMX_Event__c> SelEvt= new List<SVMXC__SVMX_Event__c>();
    List<Event> SelSFDCEvt= new List<Event>();
    List<SVMXC__Service_Order__c> UnagnWO= new List<SVMXC__Service_Order__c>();
    public SVMX_WOLatLng() {}
    public PageReference doGeoCode() {
        datetime StScheduledate=system.now();
        datetime EdScheduledate=system.now();
        date Scheduledate=system.now().dateGmt();
        
         if(SelDt != 'null' && SelDt !='' && SelDt != null){
            String yr=SelDt.substring(0, 4);
            String mn=SelDt.substring(4, 6);
            String dt=SelDt.substring(6, 8);
            Scheduledate=date.newInstance(integer.valueof(yr), integer.valueof(mn), integer.valueof(dt));
            StScheduledate=datetime.newInstance(integer.valueof(yr), integer.valueof(mn), integer.valueof(dt),00,00,00);
            EdScheduledate=datetime.newInstance(integer.valueof(yr), integer.valueof(mn), integer.valueof(dt),23,59,59);
        }
        if(SrvTeamId != 'null' && SrvTeamId != '' && (TechId == 'null' || TechId =='')){
            try{
               SelEvt=[select id,SVMXC__WhatId__c,SVMXC__Technician__c,SVMXC__ActivityDate__c from SVMXC__SVMX_Event__c where SVMXC__Technician__r.SVMXC__Service_Group__c=:SrvTeamId and SVMXC__ActivityDate__c=:Scheduledate];
               for(SVMXC__SVMX_Event__c evt:SelEvt){
                    WOLLIds.add(evt.SVMXC__WhatId__c);
               }
               SelSFDCEvt=[select id,WhatId,OwnerId,ActivityDate from Event where ActivityDate=:Scheduledate];
               for(Event evt:SelSFDCEvt){
                    WOLLIds.add(evt.WhatId);
               }
               SelWO=[select id from SVMXC__Service_Order__c where id IN:WOLLIds and 
                    (SVMXC__Latitude__c = null or SVMXC__Latitude__c = 0.000000) and 
                    (SVMXC__Longitude__c = null or SVMXC__Longitude__c = 0.000000) and
                    SVMXC__Street__c != null and SVMXC__Street__c != '' and 
                    SVMXC__City__c != null and SVMXC__City__c != '' and 
                    SVMXC__State__c != null and SVMXC__State__c != '' and 
                    SVMXC__Zip__c != null and SVMXC__Zip__c != '' and
                    Invalid_Address__c = false];
               for(SVMXC__Service_Order__c a1:SelWO){ 
                    WOIDs.add(a1.id);
               }               
            }catch(Exception E){}
           
        }else if(TechId != 'null' && TechId !=''){
            try{
             SelEvt=[select id,SVMXC__WhatId__c,SVMXC__Technician__c,SVMXC__ActivityDate__c from SVMXC__SVMX_Event__c where SVMXC__Technician__c=:TechId and SVMXC__ActivityDate__c=:Scheduledate];
               for(SVMXC__SVMX_Event__c evt:SelEvt){
                    WOLLIds.add(evt.SVMXC__WhatId__c);
               }
               SelSFDCEvt=[select id,WhatId,OwnerId,ActivityDate from Event where ActivityDate=:Scheduledate];
               for(Event evt:SelSFDCEvt){
                    WOLLIds.add(evt.WhatId);
               }
            SelWO=[select id from SVMXC__Service_Order__c where id IN:WOLLIds and 
                    (SVMXC__Latitude__c = null or SVMXC__Latitude__c = 0.000000) and 
                    (SVMXC__Longitude__c = null or SVMXC__Longitude__c = 0.000000) and
                    SVMXC__Street__c != null and SVMXC__Street__c != '' and 
                    SVMXC__City__c != null and SVMXC__City__c != '' and 
                    SVMXC__State__c != null and SVMXC__State__c != '' and 
                    SVMXC__Zip__c != null and SVMXC__Zip__c != '' and
                     Invalid_Address__c = false];
           for(SVMXC__Service_Order__c a1:SelWO){ 
                    WOIDs.add(a1.id);
               }
            }catch(Exception E){}
        } 
       
        if(StScheduledate != NULL && EdScheduledate != NULL){
            try{
            UnagnWO=[select id from SVMXC__Service_Order__c where SVMXC__Dispatch_Status__c='New' and 
                    SVMXC__Scheduled_Date_Time__c >:StScheduledate and SVMXC__Scheduled_Date_Time__c <:EdScheduledate and
                    (SVMXC__Latitude__c = null or SVMXC__Latitude__c = 0.000000) and (SVMXC__Longitude__c = null or SVMXC__Longitude__c = 0.000000) and
                    SVMXC__Street__c != null and SVMXC__Street__c != '' and SVMXC__City__c != null and SVMXC__City__c != '' and 
                    SVMXC__State__c != null and SVMXC__State__c != '' and SVMXC__Zip__c != null and SVMXC__Zip__c != ''];
            for(SVMXC__Service_Order__c a1:UnagnWO){
                WOIDs.add(a1.id);
            }
            }catch(Exception E){}

        }
        if(WOIDs.size()>0){
                
            String url='/apex/SVMX_WOLatLng?dt='+SelDt+'&tec='+TechId+'&st='+SrvTeamId;
            PageReference secondPage = new PageReference(url);
            secondPage.setRedirect(true); 
            
            integer batsize=10;
            Integer m=0;
            for(String a1:WOIDs){                
                nextbat.add(a1);          
                m=m+1;
                if(m==batsize){     
                   GoogleGeoCode4WO.go(nextbat);              
                }
                else if(WOIDs.size() < 10 && m == WOIDs.size())
                {
                    System.debug('nextbat:'+nextbat);
                    System.debug('WOIDs:'+WOIDs);
                    GoogleGeoCode4WO.go(nextbat);  
                }
                else if(m>batsize){
                    return secondPage;
                }
            }
        }
        PageReference thirdPage = new PageReference('/apex/SVMX_DrawTechRoute?dt='+SelDt+'&tec='+TechId+'&st='+SrvTeamId);
        thirdPage.setRedirect(true); 
        return thirdPage;
       
    }
    /******************************************************* Unit Test *********************************************************/
    static testMethod void SVMX_WOLatLng_UT() {
        
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
        PageReference pageRef = Page.SVMX_WOLatLng;
        pageRef.getParameters().put('dt',String.valueof(yr+mn+dte));
        pageRef.getParameters().put('tec',Tech.Id);
        pageRef.getParameters().put('st',ST.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_WOLatLng thisPageCon = new SVMX_WOLatLng();
       
       PageReference pgrf = thisPageCon.doGeoCode();
       
       //Test converage for the visualforce page
        PageReference pageRef1 = Page.SVMX_WOLatLng;
        pageRef1.getParameters().put('dt',String.valueof(yr+mn+dte));
        pageRef1.getParameters().put('tec','');
        pageRef1.getParameters().put('st',ST.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // create an instance of the controller
        SVMX_WOLatLng thisPageCon1 = new SVMX_WOLatLng();
       
       PageReference pgrf1 = thisPageCon1.doGeoCode();
    }
}