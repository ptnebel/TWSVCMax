public class SVMX_DrawUSRmap {
    String xMapStr='';
    String key;
    public SVMX_DrawUSRmap(){
        /*SVMXC.COMM_Utils_ManageSettings settings = new SVMXC.COMM_Utils_ManageSettings();
        Map<String, String> mySettings = settings.SVMX_getSettingList('CUSTSUB002','CUSTSET001');
        key= mySettings.get('CUSTSET001');
        System.debug('key:'+key);*/
        
         SVMXC__Dispatcher_Access__c DispAccs=null;
        xMapStr='';
        try{
            DispAccs=[select SVMXC__Service_Team__c,SVMXC__Service_Team__r.SVMXC__Latitude__c,
                    SVMXC__Service_Team__r.SVMXC__Longitude__c,SVMXC__Service_Team__r.Name 
                    from SVMXC__Dispatcher_Access__c where SVMXC__Dispatcher__c=:UserInfo.getUserId() and SVMXC__Service_Team__c <> NULL
                    and SVMXC__Service_Team__r.SVMXC__Latitude__c<>NULL and SVMXC__Service_Team__r.SVMXC__Longitude__c<>NULL and Preferred_Service_Team__c=true limit 1];
                    
            xMapStr=xMapStr+DispAccs.SVMXC__Service_Team__r.SVMXC__Latitude__c+':'+DispAccs.SVMXC__Service_Team__r.SVMXC__Longitude__c+':'+
                    DispAccs.SVMXC__Service_Team__c+':'+DispAccs.SVMXC__Service_Team__r.Name;
            
        }catch(Exception E){
            User usr =[Select Name, MobilePhone, Longtitude__c, Latitude__c, Id, Email From User where id=:UserInfo.getUserId()];
            
            xMapStr=xMapStr+usr.Latitude__c+':'+usr.Longtitude__c+':'+usr.Id+':'+usr.Name;
        }
    }
    public string getMapStr(){
        return xMapStr;
    }
    public string getmyKey(){
        String key='ABQIAAAASeLn86_eKPE1zeDspxFbFxQdMY-rqcBK7mOLf4exckLw5w98-BSbrnMwn2CB7tQFrtb6vBKGwd396Q';
        return key;
    }
    
    /******************************************************* Unit Test *********************************************************/
    static testMethod void SVMX_DrawUSRmap_UT() {
        
        Profile p = [select id from profile where name='System Administrator'];
         User u = new User(alias = 'standt', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='standarduser@testLenn.com',Latitude__c=38.98163,Longtitude__c=94.71923);
         System.runAs(u) {
            // create an instance of the controller
            SVMX_DrawUSRmap thisPageCon1 = new SVMX_DrawUSRmap();
         }
        
        SVMXC__Service_Group__c ST= new SVMXC__Service_Group__c(Name='TstSrvTeam',
                                                                SVMXC__Active__c=true,
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                SVMXC__Country__c='United States',
                                                                SVMXC__Zip__c='29910',
                                                                SVMXC__Latitude__c=null,
                                                                SVMXC__Longitude__c=null                                                                
                                                                );
        insert ST;
        
        SVMXC__Dispatcher_Access__c Disp= new SVMXC__Dispatcher_Access__c(SVMXC__Dispatcher__c=UserInfo.getUserId(),
                                                                SVMXC__Service_Team__c=ST.id
                                                                );
        insert Disp;
        
        //Test converage for the visualforce page
        PageReference pageRef = Page.SVMX_DrawUSRmap;
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_DrawUSRmap thisPageCon = new SVMX_DrawUSRmap();
        String temp;
        temp=thisPageCon.getMapStr();
        temp=thisPageCon.getmyKey();
    }
}