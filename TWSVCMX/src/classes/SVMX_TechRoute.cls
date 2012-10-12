public class SVMX_TechRoute {
    String SelDt=System.currentPageReference().getParameters().get('dt');
    String TechId=System.currentPageReference().getParameters().get('tec');
    String SrvTeamId=System.currentPageReference().getParameters().get('st');
    String atofrsh=System.currentPageReference().getParameters().get('autofrsh');
    Boolean autofresh=false;
    String url;
    SVMXC__Service_Order__c st_wo;
    public SVMX_TechRoute(){
        try{
            User usr=[Select Name, Id From User where Longtitude__c = null and Latitude__c=null and id=:UserInfo.getUserId()];
            url='/apex/SVMX_USRLatLng';
        }catch(Exception E){
            url='/apex/SVMX_DrawUSRmap';
        }
        if((SrvTeamId != 'null' && SrvTeamId != '' || TechId != 'null' && TechId !='') && SelDt != null && SelDt !=''){
            String yr=SelDt.substring(0, 4);
            String mn=SelDt.substring(4, 6);
            String dt=SelDt.substring(6, 8);
            date sdt=date.newInstance(integer.valueof(yr), integer.valueof(mn), integer.valueof(dt));
            if(SrvTeamId != 'null' && SrvTeamId != '')
                st_wo = new SVMXC__Service_Order__c(SVMXC__Service_Group__c=SrvTeamId,SVMXC__Scheduled_Date__c=sdt);
            if(TechId != 'null' && TechId != '')
                st_wo = new SVMXC__Service_Order__c(SVMXC__Group_Member__c=TechId,SVMXC__Scheduled_Date__c=sdt);
            ShowRoute();
        }else{
            st_wo = new SVMXC__Service_Order__c();
        }
    }
    public SVMXC__Service_Order__c getWO(){
        return st_wo;
    }
    public void setWO(SVMXC__Service_Order__c st_wo){
        this.st_wo=st_wo;
    }
    public Boolean getautofresh(){
        return autofresh;
    }
    public String getURL(){
        return url;
    }
    public PageReference ShowRoute(){                
        if(st_wo.SVMXC__Scheduled_Date__c != null && (st_wo.SVMXC__Group_Member__c != null || st_wo.SVMXC__Service_Group__c != null)){
            autofresh=true;
            String dat=String.valueOf(st_wo.SVMXC__Scheduled_Date__c).substring(0,4)+String.valueOf(st_wo.SVMXC__Scheduled_Date__c).substring(5,7)+
                    String.valueOf(st_wo.SVMXC__Scheduled_Date__c).substring(8,10);
            url='/apex/SVMX_TechLatLng?dt='+dat+'&tec='+st_wo.SVMXC__Group_Member__c+'&st='+st_wo.SVMXC__Service_Group__c+'&autofrsh='+atofrsh;
           
        }else
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Please Enter Service Team or Technician and Scheduled Date!'));
        return null;
    }
    public PageReference Reset(){
        PageReference secondPage = new PageReference('/apex/SVMX_TechRoute?dt=null&tec=null&st=null&autofrsh=0');
        secondPage.setRedirect(true); 
        return secondPage;    
    }
    public PageReference autorefresh(){
        if(st_wo.SVMXC__Scheduled_Date__c != null && (st_wo.SVMXC__Group_Member__c != null || st_wo.SVMXC__Service_Group__c != null)){
            String dat1=String.valueOf(st_wo.SVMXC__Scheduled_Date__c).substring(0,4)+String.valueOf(st_wo.SVMXC__Scheduled_Date__c).substring(5,7)+
                    String.valueOf(st_wo.SVMXC__Scheduled_Date__c).substring(8,10);
            PageReference secondPage = new PageReference('/apex/SVMX_TechRoute?dt='+dat1+'&tec='+st_wo.SVMXC__Group_Member__c+'&st='+st_wo.SVMXC__Service_Group__c+'&autofrsh=1');
            secondPage.setRedirect(true); 
            return secondPage;    
        }
        return null;
    }
    
    
     /******************************************************* Unit Test *********************************************************/
    static testMethod void SVMX_TechRoute_UT() {
        
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
                                                                //Center__c='108',
                                                                //STARS_Technician_Number__c='108-00209',
                                                                SVMXC__Service_Group__c=ST.Id,
                                                                SVMXC__Phone__c='330-518-4973',
                                                                SVMXC__Enable_Scheduling__c=true,
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                SVMXC__Zip__c='29910'
                                                                );
        insert Tech;
        
        String yr=String.valueOf(system.now().year());
        String mn=String.valueOf(system.now().month());
        if(mn.length()<2)
            mn='0'+mn;
        String dte=String.valueOf(system.now().day());
        if(dte.length()<2)
            dte='0'+dte;
                
        //Test coverage for the visualforce page
        PageReference pageRef = Page.SVMX_TechRoute;
        pageRef.getParameters().put('dt',String.valueof(yr+mn+dte));
        pageRef.getParameters().put('tec',Tech.Id);
        pageRef.getParameters().put('st',ST.Id);
        pageRef.getParameters().put('autofrsh','0');
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_TechRoute thisPageCon = new SVMX_TechRoute();
        
        SVMXC__Service_Order__c wo= new SVMXC__Service_Order__c();
        
        wo=thisPageCon.getWO();
        thisPageCon.setWO(wo);
        boolean tempBl= thisPageCon.getautofresh();
        String temp= thisPageCon.getURL();
                
       PageReference pgrf = thisPageCon.autorefresh();
       PageReference pgrf1 = thisPageCon.Reset();
       
       //Test coverage for the visualforce page
        PageReference pageRef1 = Page.SVMX_TechRoute;
        pageRef1.getParameters().put('dt',String.valueof(yr+mn+dte));
        pageRef1.getParameters().put('tec','');
        pageRef1.getParameters().put('st',ST.Id);
        pageRef1.getParameters().put('autofrsh','0');
        Test.setCurrentPageReference(pageRef1);
        
        // create an instance of the controller
        SVMX_TechRoute thisPageCon1 = new SVMX_TechRoute();
    }
}