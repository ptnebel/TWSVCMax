global class GoogleGeoCode4WO {
    private static String key='ABQIAAAASeLn86_eKPE1zeDspxFbFxQdMY-rqcBK7mOLf4exckLw5w98-BSbrnMwn2CB7tQFrtb6vBKGwd396Q';
    public GoogleGeoCode4WO(ApexPages.StandardController controller) {
        
    }
    public GoogleGeoCode4WO() {
       /* SVMXC.COMM_Utils_ManageSettings settings = new SVMXC.COMM_Utils_ManageSettings();
        Map<String, String> mySettings = settings.SVMX_getSettingList('CUSTSUB002','CUSTSET001');
        key= mySettings.get('CUSTSET001');
        System.debug('key:'+key);*/
    }
    
    public static integer debug = 1;
    
    private static final map<string,string> config = new map<string, string>();
   
    private static final string serviceUrl = 'http://maps.google.com/maps/geo?key='+key;
    
   // @future (callout=true)
    public static void geocodeWO( list<string> ids ) { 
        List<SVMXC__Service_Order__c> a2 = new List<SVMXC__Service_Order__c>();
        // fetch the address from this account(s) 
        SVMXC__Service_Order__c[] al = [ select id, name, SVMXC__Street__c,SVMXC__City__c,GeoViaTrigger__c,
            SVMXC__State__c,SVMXC__Country__c,SVMXC__Zip__c,SVMXC__Latitude__c,SVMXC__Longitude__c,Invalid_Address__c from SVMXC__Service_Order__c where id in :ids];
         
        // store the resulting lat-lon in the accounts
        for ( SVMXC__Service_Order__c a: al) { 
            System.debug('al:'+a.id);
           string adr = ''; 
            if(a.SVMXC__Street__c != null && a.SVMXC__Street__c != '')
                adr =adr+a.SVMXC__Street__c + ',';
            if(a.SVMXC__City__c != null && a.SVMXC__City__c != '')
                adr =adr+a.SVMXC__City__c + ',';
            if(a.SVMXC__State__c != null && a.SVMXC__State__c != '')
                adr =adr+a.SVMXC__State__c + ',';
            if(a.SVMXC__Country__c != null && a.SVMXC__Country__c != '')
                adr =adr+a.SVMXC__Country__c + ','; 
            if ( a.SVMXC__Zip__c != null && a.SVMXC__Zip__c != ''){ 
                String zip=String.valueOf(a.SVMXC__Zip__c);
                if(zip.length()>=5) 
                 adr += ',' + a.SVMXC__Zip__c; 
            }
            SVMX_XMLDom dom = geocode(adr); 
            processGeocodeDom ( dom , a);
        }
        /*
        for ( SVMXC__Service_Order__c a: al) {
            if(a.SVMXC__Latitude__c != null && a.SVMXC__Longitude__c != null){
                a2.add(a);
            }
        }*/
        if(al.size()>0)
            update al;
    }
    
    /* given a DOM, look at the code and store the values or error found */
    public static void processGeocodeDom( SVMX_XMLDom dom, SVMXC__Service_Order__c a ) {
        if (dom != null) {          
            if ( dom.root.getValue('code') == '200' )  {
                string[] lat_lon = dom.root.getValue('coordinates' ).split(',');
                a.SVMXC__Latitude__c = Double.valueOf(lat_lon[1]); 
                a.SVMXC__Longitude__c = Double.valueOf(lat_lon[0]); 
               // a.geocode_status__c = 'G_GEO_SUCCESS';
            } else { 
               a.Invalid_Address__c = true;            
            }     
        }
    }
    
  /*
    static Map<String, String> geo_response = new Map<String, String>{'200'=>'G_GEO_SUCCESS',
    '400'=>'G_GEO_BAD_REQUEST',
    '500'=>'G_GEO_SERVER_ERROR',
    '601'=>'G_GEO_MISSING_ADDRESS',
    '602'=>'G_GEO_UNKNOWN_ADDRESS',
    '603'=>'G_GEO_UNAVAILABLE_ADDRESS',
    '604'=>'G_GEO_UNKNOWN_DIRECTIONS',
    '610'=>'G_GEO_BAD_KEY',
    '620'=>'G_GEO_TOO_MANY_QUERIES'
    };
        
    the call may return one of these  Constants
    Constants   Description
    G_GEO_SUCCESS (200)     No errors occurred; the address was successfully parsed and its geocode has been returned. (Since 2.55)
    G_GEO_BAD_REQUEST (400)     A directions request could not be successfully parsed. (Since 2.81)
    G_GEO_SERVER_ERROR (500)    A geocoding or directions request could not be successfully processed, yet the exact reason for the failure is not known. (Since 2.55)
    G_GEO_MISSING_QUERY (601)   The HTTP q parameter was either missing or had no value. For geocoding requests, this means that an empty address was specified as input. For directions requests, this means that no query was specified in the input. (Since 2.81)
    G_GEO_MISSING_ADDRESS (601)     Synonym for G_GEO_MISSING_QUERY. (Since 2.55)
    G_GEO_UNKNOWN_ADDRESS (602)     No corresponding geographic location could be found for the specified address. This may be due to the fact that the address is relatively new, or it may be incorrect. (Since 2.55)
    G_GEO_UNAVAILABLE_ADDRESS (603)     The geocode for the given address or the route for the given directions query cannot be returned due to legal or contractual reasons. (Since 2.55)
    G_GEO_UNKNOWN_DIRECTIONS (604)  The GDirections object could not compute directions between the points mentioned in the query. This is usually because there is no route available between the two points, or because we do not have data for routing in that region. (Since 2.81)
    G_GEO_BAD_KEY (610)     The given key is either invalid or does not match the domain for which it was given. (Since 2.55)
    G_GEO_TOO_MANY_QUERIES (620)    The given key has gone over the requests limit in the 24 hour period. (Since 2.55)
    */
    public static SVMX_XMLDom geocode( string addr ) { 
        HttpRequest req = new HttpRequest();   
        string url = GoogleGeoCode4WO.serviceUrl + '&output=xml&q=' + EncodingUtil.urlEncode(addr,'UTF-8');
        system.debug ( 'url is ' +url );
        req.setEndpoint( url );
        req.setMethod('GET');
        
        SVMX_XMLDom dom = null;
        try {
            Http http = new Http();
            HttpResponse response = http.send(req);
            
            if (response.getStatusCode() != 200 ) { 
                System.debug('BODY: '+response.getBody());              
                dumpResponse ( response);
            } else {
                System.debug('BODY: '+response.getBody());
                dom = new SVMX_XMLDom( response.getBody() );
            } 
        } catch( System.Exception e) {
            System.debug('ERROR: '+ e);
        }  
        
        //if ( GoogleGeoCode4WO.debug > 0 && dom != null ) { 
        //  dom.dumpAll(); 
        //} 
        return dom;
    }
    
    private static void dumpResponse(HttpResponse response) { 
        system.debug('GEOCODE ERROR: Could not parse or locate address'); 
        System.debug('STATUS:'+response.getStatus());
        System.debug('STATUS_CODE:'+response.getStatusCode());
        System.debug('BODY: '+response.getBody());
       // SVMX_XMLDom dom = new SVMX_XMLDom( response.getBody() );
        //dom.dumpAll();
    }
    webService static void go( list<string> woid ) {
        geocodeWO( woid );
    }   

   /*webService static void go( string accid ) {
        geocodeOneAccount( accid );
    } */
    
    // Test methods below here     
    
    public static  testmethod void t1() {
        string test_resp = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>Elm St. Chico CA null</name><Status><code>602</code><request>geocode</request></Status></Response></kml>';
        
        SVMXC__Service_Order__c a =  new SVMXC__Service_Order__c();
        a.SVMXC__Street__c = '1600 Amphitheatre Parkway';
        a.SVMXC__City__c = 'Mountain View';
        a.SVMXC__State__c = 'CA';
        a.SVMXC__Country__c = 'USA';
        a.SVMXC__Zip__c='94043';
        try { insert a; } catch ( system.dmlexception de) {}
        List<String> wostr = new List<String>();
        wostr.add(a.id);
        GoogleGeoCode4WO.go( wostr );
        
        //GoogleGeoCode4WO.dumpResponse( new HttpResponse() );
    }
    
     public static testmethod void testgeocode() { 
        
        SVMX_XMLDom dom = GoogleGeoCode4WO.geocode('1600 Amphitheatre Parkway, Mountain View, CA');     
    
        if ( dom == null ) { 
            // when testing, dom is null here, fill it in with a valid dom.
            return;
        }
        system.debug( dom.toXmlString() );
        system.assert ( dom.root.getValue('code') == '200' , ' bad return code getValue() ');
        
        system.debug(  dom.root.getValue('coordinates' ));
        string[] lat_lon = dom.root.getValue('coordinates' ).split(',');
        system.debug( lat_lon );
        
        // we expect a 602 here
        dom = GoogleGeoCode4WO.geocode('1600 a Parkway,  View, GA');
        system.debug ( 'code is '   +dom.root.getValue('code'));
        system.assert ( dom.root.getValue('code') == '602' , ' unexpected return code');
        
    }
    
    public static testmethod void t3() { 
        string test_resp = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>Elm St. Chico CA null</name><Status><code>602</code><request>geocode</request></Status></Response></kml>';
        string test_resp2 = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0" ><Response ><name >1600 Amphitheatre Parkway, Mountain View, CA</name><Status ><code >200</code><request >geocode</request></Status><Placemark id="p1" ><address >1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA</address><Point ><coordinates >-122.085121,37.423088,0</coordinates></Point></Placemark></Response></kml>';
        SVMXC__Service_Order__c a = new SVMXC__Service_Order__c() ; 
        GoogleGeoCode4WO.processGeocodeDom( new SVMX_XMLDom( test_resp) ,a);  
        GoogleGeoCode4WO.processGeocodeDom( new SVMX_XMLDom( test_resp2) ,a);  
    } 
     public static testmethod void t4() { 
        GoogleGeoCode4WO geo = new GoogleGeoCode4WO();      
        SVMXC__Service_Order__c a = new SVMXC__Service_Order__c() ;   
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        GoogleGeoCode4WO geo2 = new GoogleGeoCode4WO(sc); 
    } 
}