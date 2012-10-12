public class SVMX_TechLatLng {
    String SelDt=System.currentPageReference().getParameters().get('dt');
    String TechId=System.currentPageReference().getParameters().get('tec');
    String SrvTeamId=System.currentPageReference().getParameters().get('st');
    String atofrsh=System.currentPageReference().getParameters().get('autofrsh');
    List<SVMXC__Service_Group_Members__c> TechList = new List<SVMXC__Service_Group_Members__c>();
    List<String> nextbat =new List<String>();
    public SVMX_TechLatLng(){
        System.debug('SelDt'+SelDt);
        System.debug('TechId'+TechId);
        System.debug('SrvTeamId'+SrvTeamId);
        if(SrvTeamId != 'null' && SrvTeamId != '' && (TechId == 'null' || TechId =='')){
            TechList = [select id from SVMXC__Service_Group_Members__c where SVMXC__Service_Group__c=:SrvTeamId and SVMXC__Latitude__c = null and SVMXC__Longitude__c = null ];
        }else if(TechId != 'null' && TechId !=''){
            TechList = [select id from SVMXC__Service_Group_Members__c where id=:TechId and SVMXC__Latitude__c = null and SVMXC__Longitude__c = null];
        }        
    }
    public PageReference fnTechLatLng() {
        PageReference secondPage = new PageReference('/apex/SVMX_TechLatLng?dt='+SelDt+'&tec='+TechId+'&st='+SrvTeamId);
        secondPage.setRedirect(true);
         
        integer batsize=10;
        Integer m=0;
        if(TechList.size()>0){
            for(Integer i=0;i<TechList.size();i++){                
                nextbat.add(TechList.get(i).id);          
                m=m+1;
                if(m==batsize){             
                    GoogleGeoCode4Tech.go(nextbat);              
                }
                else if(TechList.size() < 10 && m == TechList.size())
                {
                    GoogleGeoCode4Tech.go(nextbat);  
                }
                else if(m>batsize){
                    return secondPage;
                }
            }
        }
        /*if(atofrsh=='1'){
            PageReference thirdPage = new PageReference('/apex/SVMX_DrawTechRoute?dt='+SelDt+'&tec='+TechId+'&st='+SrvTeamId);
            thirdPage.setRedirect(true); 
            return thirdPage;
        }else{*/
            PageReference Fourpage = new PageReference('/apex/SVMX_WOLatLng?dt='+SelDt+'&tec='+TechId+'&st='+SrvTeamId);
            Fourpage.setRedirect(true); 
            return Fourpage;
        //}
    }
    
     /******************************************************* Unit Test *********************************************************/
    static testMethod void SVMX_TechLatLng_UT() {
        
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
                                                                SVMXC__Latitude__c=null,
                                                                SVMXC__Longitude__c=null,
                                                                SVMXC__Service_Group__c=ST.Id,
                                                                SVMXC__Phone__c='330-518-4973',
                                                                SVMXC__Enable_Scheduling__c=true,
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                SVMXC__Zip__c='29910'
                                                                );
        insert Tech;
                
        //Test converage for the visualforce page
        PageReference pageRef = Page.SVMX_TechLatLng;
        pageRef.getParameters().put('dt',String.valueof(System.today()));
        pageRef.getParameters().put('tec',Tech.Id);
        pageRef.getParameters().put('st',ST.Id);
        pageRef.getParameters().put('autofrsh','0');
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_TechLatLng thisPageCon = new SVMX_TechLatLng();
       
       PageReference pgrf = thisPageCon.fnTechLatLng();
       
       //Test converage for the visualforce page
        PageReference pageRef1 = Page.SVMX_TechLatLng;
        pageRef1.getParameters().put('dt',String.valueof(System.today()));
        pageRef1.getParameters().put('tec','');
        pageRef1.getParameters().put('st',ST.Id);
        pageRef1.getParameters().put('autofrsh','0');
        Test.setCurrentPageReference(pageRef1);
        
        // create an instance of the controller
        SVMX_TechLatLng thisPageCon1 = new SVMX_TechLatLng();
       
       PageReference pgrf1 = thisPageCon1.fnTechLatLng();
    }

}