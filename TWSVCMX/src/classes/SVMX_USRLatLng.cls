public class SVMX_USRLatLng {
    Boolean Show=true;
    public Boolean getShow(){
        return Show;
    }
    public SVMX_USRLatLng(){}
    public PageReference fnUSRLatLng() {
        try{
            
            SVMXC__Dispatcher_Access__c DispAccs=[select id,SVMXC__Service_Team__c
                    from SVMXC__Dispatcher_Access__c where SVMXC__Dispatcher__c=:UserInfo.getUserId() and SVMXC__Service_Team__c <> NULL
                    and Preferred_Service_Team__c=true limit 1];
			
			SVMXC__Service_Group__c ST1=[select id,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__Street__c,SVMXC__City__c,
                    SVMXC__State__c,SVMXC__Country__c,SVMXC__Zip__c from SVMXC__Service_Group__c where id=:DispAccs.SVMXC__Service_Team__c and SVMXC__Latitude__c=NULL and SVMXC__Longitude__c=NULL];
            
            SVMX_XMLDom dom =geolatlng(ST1.SVMXC__Street__c,ST1.SVMXC__City__c,ST1.SVMXC__State__c,ST1.SVMXC__Country__c,ST1.SVMXC__Zip__c);
                if(dom != null){
                    PageReference pgrf = processDomDA(dom,DispAccs);
                    return pgrf;
                }else{
                    Show=false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Proper Address in your Service Team!'));
                    return null;
                }
                    
        }catch(Exception E){
            PageReference RePage1 = new PageReference('/apex/SVMX_DrawUSRmap');
            RePage1.setRedirect(true);
            try{    
            User usr =[Select Street, State, PostalCode, Longtitude__c, Latitude__c, Country, City From User where id=:UserInfo.getUserId() 
                        and Longtitude__c=NULL and Latitude__c=NULL];
                SVMX_XMLDom dom =geolatlng(usr.Street,usr.City,usr.State,usr.Country,usr.PostalCode);
                if(dom != null){
                    PageReference pgrf1 = processDomUSR(dom,usr);
                    return pgrf1;
                }else{
                    Show=false;
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Proper Address in your Profile Infomation!'));
                    return RePage1;
                }
            }catch(Exception E1){
                return RePage1;
            }
        }
    }
    public static SVMX_XMLDom geolatlng(string street,string city,string state,string country,string zip){
        
        string addr = ''; 
            if ( street != null && street != '') 
                addr += street;
            if ( city != null && city != '') 
                addr += ',' + city;
            if ( state != null && state != '') 
                addr += ',' + state;
            if ( country != null && country != '') 
                addr += ',' + country;
            if ( zip != null && zip != '') {
                String zip1=String.valueOf(zip);
                if(zip1.length()>=5) 
                addr += ',' + zip1.substring(0, 5); 
            }
        HttpRequest req = new HttpRequest();   
        string url = 'http://maps.google.com/maps/geo?key=ABQIAAAASeLn86_eKPE1zeDspxFbFxQ68vtBDFrLPSwmMuiJAu3TH4ieoxQXpkcqu9lDFou78lf8BBdCCIza2A';
        url += '&output=xml&q=' + EncodingUtil.urlEncode(addr,'UTF-8');
        system.debug ( 'url is ' +url );
        req.setEndpoint( url );
        req.setMethod('GET');
        
        SVMX_XMLDom dom = null;
        try {
            Http http = new Http();
            HttpResponse response = http.send(req);
            System.debug('BODY: '+response.getBody());
            if (response.getStatusCode() != 200 ) {
               system.debug ( 'Failure Body : ' +response.getBody() );
            } else {
                dom = new SVMX_XMLDom(response.getBody());
            } 
        } catch( System.Exception e) {
            System.debug('ERROR: '+ e.getMessage());
        }         
        return dom;
    }
    
    public PageReference processDomDA( SVMX_XMLDom dom, SVMXC__Dispatcher_Access__c DispAccs ) {
        system.debug('dom'+dom);
         if ( dom.root.getValue('code') == '200' )  {
            string[] lat_lon = dom.root.getValue('coordinates').split(',');
            SVMXC__Service_Group__c ST = new SVMXC__Service_Group__c(id=DispAccs.SVMXC__Service_Team__c);
            ST.SVMXC__Latitude__c = Double.valueOf(lat_lon[1]); 
            ST.SVMXC__Longitude__c = Double.valueOf(lat_lon[0]); 
            update ST;
            
            PageReference RePage = new PageReference('/apex/SVMX_DrawUSRmap');
            RePage.setRedirect(true); 
            return RePage;
        } else { 
            Show=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Proper Address in your Service Team!'));
            return null;            
        }
    }
    
    public PageReference processDomUSR( SVMX_XMLDom dom, User usr ) {
        system.debug('dom'+dom);
         if ( dom.root.getValue('code') == '200' )  {
            string[] lat_lon = dom.root.getValue('coordinates').split(',');
            usr.Latitude__c = Double.valueOf(lat_lon[1]); 
            usr.Longtitude__c = Double.valueOf(lat_lon[0]); 
            update usr;
            
            PageReference RePage = new PageReference('/apex/SVMX_DrawUSRmap');
            RePage.setRedirect(true); 
            return RePage;
        } else { 
            Show=false;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Proper Address in your Profile Infomation!'));
            PageReference RePage = new PageReference('/apex/SVMX_DrawUSRmap');
            RePage.setRedirect(true); 
            return RePage;          
        }
    }
    
    /******************************************************* Unit Test *********************************************************/
    static testMethod void SVMX_USRLatLng_UT() {
      
        Profile p = [select id from profile where name='System Administrator'];
         User u = new User(alias = 'standt', email='standarduser@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, Street='1630 Fording Island Rd', State='GA', PostalCode='29910', Country='United States', City='Bluffton',
            timezonesidkey='America/Los_Angeles', username='standarduser@testLenn.com',Latitude__c=Null,Longtitude__c=Null);
         System.runAs(u) {
            // create an instance of the controller
            SVMX_USRLatLng thisPageCon1 = new SVMX_USRLatLng();
            PageReference pRef = thisPageCon1.fnUSRLatLng();
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
        PageReference pageRef = Page.SVMX_USRLatLng;
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_USRLatLng thisPageCon = new SVMX_USRLatLng();
        PageReference pRef1 =thisPageCon.fnUSRLatLng();
        Boolean temp=thisPageCon.getShow();
    }
    public static testmethod void t3() { 
        string test_resp = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>Elm St. Chico CA null</name><Status><code>602</code><request>geocode</request></Status></Response></kml>';
        string test_resp2 = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0" ><Response ><name >1600 Amphitheatre Parkway, Mountain View, CA</name><Status ><code >200</code><request >geocode</request></Status><Placemark id="p1" ><address >1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA</address><Point ><coordinates>-122.085121,37.423088,0</coordinates></Point></Placemark></Response></kml>';
        SVMXC__Dispatcher_Access__c a = [select SVMXC__Service_Team__c,SVMXC__Service_Team__r.SVMXC__Latitude__c,
                    SVMXC__Service_Team__r.SVMXC__Longitude__c,SVMXC__Service_Team__r.SVMXC__Street__c,SVMXC__Service_Team__r.SVMXC__City__c,
                    SVMXC__Service_Team__r.SVMXC__State__c,SVMXC__Service_Team__r.SVMXC__Country__c,SVMXC__Service_Team__r.SVMXC__Zip__c
                    from SVMXC__Dispatcher_Access__c limit 1]; //where SVMXC__Dispatcher__c=:UserInfo.getUserId() 
        User a1 =[Select Street, State, PostalCode, Longtitude__c, Latitude__c, Country, City From User where id=:UserInfo.getUserId()]; 
        SVMX_USRLatLng thisPageCon = new SVMX_USRLatLng();
        PageReference pRef;
        pRef = thisPageCon.processDomDA( new SVMX_XMLDom( test_resp) ,a);  
        pRef = thisPageCon.processDomDA( new SVMX_XMLDom( test_resp2) ,a); 
        pRef = thisPageCon.processDomUSR( new SVMX_XMLDom( test_resp) ,a1);  
        pRef = thisPageCon.processDomUSR( new SVMX_XMLDom( test_resp2) ,a1); 
    }
}