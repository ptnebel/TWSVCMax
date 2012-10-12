global class GoogleGeoCode4Tech {
    //private static String key='ABQIAAAASeLn86_eKPE1zeDspxFbFxQdMY-rqcBK7mOLf4exckLw5w98-BSbrnMwn2CB7tQFrtb6vBKGwd396Q';
    public GoogleGeoCode4Tech(ApexPages.StandardController controller) {
        
    }
    public GoogleGeoCode4Tech() {
       
    }
    /*
    Geocoding via HTTP

You may also access the Maps API geocoder directly using server-side scripting. 
This method is not recommended over using the client-side geocoder; however, it is useful for debugging purposes 
or for cases where a JavaScript GClientGeocoder object is not available.

To access the Maps API Geocoder, send a request to http://maps.google.com/maps/geo? with the following parameters in the URI:

    * q (required) — The address that you want to geocode.
    * key (required) — Your API key.
    * output (required) — The format in which the output should be generated. The options are xml, kml, csv, or (default) json.
    * ll (optional) — The {latitude,longitude} of the viewport center expressed as a comma-separated string (e.g. "ll=40.479581,-117.773438" ). This parameter only has meaning if the spn parameter is also passed to the geocoder.
    * spn (optional) — The "span" of the viewport expressed as a comma-separated string of {latitude,longitude} (e.g. "spn=11.1873,22.5" ). This parameter only has meaning if the ll parameter is also passed to the geocoder.
    * gl (optional) — The country code, specified as a ccTLD ("top-level domain") two-character value.

Note: The gl and spn,ll viewport parameters will only influence, not fully restrict, results from the geocoder.

In this example, we request the geographic coordinates of Google's headquarters:

http://maps.google.com/maps/geo?q=1600+Amphitheatre+Parkway,+Mountain+View,+CA&output=xml&key=abcdefg

If you specify json as the output, the response is formatted as a JSON object. If you specify xml or kml, the response is returned in KML. The XML and KML outputs are identical except for the MIME types.

    */
    public static integer debug = 1;
    
    private static final map<string,string> config = new map<string, string>();
   
    private static final string serviceUrl = 'http://maps.google.com/maps/geo';
    
    @future (callout=true)
    public static void geocodeWO( list<string> ids ) { 
    
        // fetch the address from this account(s) 
        SVMXC__Service_Group_Members__c[] al = [ select id, name, SVMXC__Street__c,SVMXC__City__c,SVMXC__Latitude__c,SVMXC__Longitude__c,
            SVMXC__State__c,SVMXC__Country__c,SVMXC__Zip__c,Home_Latitude__c,Home_Longitude__c from SVMXC__Service_Group_Members__c where id in :ids];
         
        // store the resulting lat-lon in the accounts
        for ( SVMXC__Service_Group_Members__c a: al) { 
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
                 adr += ',' + a.SVMXC__Zip__c.substring(0, 5); 
            }
            xmldom dom = geocode(adr); 
            processGeocodeDom ( dom , a);
        }
        update al;
    }
    
    /* given a DOM, look at the code and store the values or error found */
    public static void processGeocodeDom( xmldom dom, SVMXC__Service_Group_Members__c a ) {
        if (dom != null) {          
            if ( dom.root.getValue('code') == '200' )  {
                string[] lat_lon = dom.root.getValue('coordinates' ).split(',');
                a.Home_Latitude__c = Double.valueOf(lat_lon[1]); 
                a.Home_Longitude__c = Double.valueOf(lat_lon[0]); 
                a.SVMXC__Latitude__c= Double.valueOf(lat_lon[1]); 
                a.SVMXC__Longitude__c= Double.valueOf(lat_lon[0]); 
               //a.GeoViaTrigger__c=false; 
               // a.geocode_status__c = 'G_GEO_SUCCESS';
            } 
            /*else { 
                a.Home_Latitude__c = null; a.Home_Longitude__c = null;              
            }*/
        }
    }
    
   /*public static void geocodeOneWO(string woid) {
       SVMXC__Service_Order__c a = [ select id, name, SVMXC__Street__c,SVMXC__City__c,
            SVMXC__State__c,SVMXC__Country__c,SVMXC__Zip__c,SVMXC__Latitude__c,SVMXC__Longitude__c from SVMXC__Service_Order__c where id = :woid limit 1];      
        
        string adr = a.SVMXC__Street__c + ',' + a.SVMXC__City__c + ',' + a.SVMXC__State__c; 
        if ( a.SVMXC__Zip__c != null ) 
            adr += ',' + a.SVMXC__Zip__c.substring(0, 5); 
            
        xmldom dom = geocode(adr); 
        processGeocodeDom ( dom , a);
        
        if ( dom != null ) {
            update a;   
        }

    }
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
    public static xmldom geocode( string addr ) { 
        SVMXC.COMM_Utils_ManageSettings settings = new SVMXC.COMM_Utils_ManageSettings();
        Map<String, String> mySettings = settings.SVMX_getSettingList('CUSTSUB002','CUSTSET001');
        String key= mySettings.get('CUSTSET001');
        System.debug('key:'+key);
        
        HttpRequest req = new HttpRequest();   
        string url = GoogleGeoCode4Tech.serviceUrl+'?key='+key+'&output=xml&q=' + EncodingUtil.urlEncode(addr,'UTF-8');
        system.debug ( 'url is ' +url );
        req.setEndpoint( url );
        req.setMethod('GET');
        
        xmldom dom = null;
        try {
            Http http = new Http();
            HttpResponse response = http.send(req);
            
            if (response.getStatusCode() != 200 ) {             
                dumpResponse ( response);
            } else {
                dom = new xmldom( response.getBody() );
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
       // xmldom dom = new xmldom( response.getBody() );
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
        SVMXC__Service_Group__c ST= new SVMXC__Service_Group__c(Name='TstSrvTeam',
                                                                SVMXC__Active__c=true,
                                                                SVMXC__Street__c='1630 Fording Island Rd',
                                                                SVMXC__City__c='Bluffton',
                                                                SVMXC__State__c='GA',
                                                                SVMXC__Country__c='United States',
                                                                SVMXC__Zip__c='29910'                                                               
                                                                );
        insert ST;
        SVMXC__Service_Group_Members__c a =  new SVMXC__Service_Group_Members__c(Name='TstTech',
                                                                SVMXC__Active__c=true,SVMXC__Service_Group__c=ST.Id);
        a.SVMXC__Street__c = '1600 Amphitheatre Parkway';
        a.SVMXC__City__c = 'Mountain View';
        a.SVMXC__State__c = 'CA';
        a.SVMXC__Country__c = 'USA';
        a.SVMXC__Zip__c='94043';
        try { insert a; } catch ( system.dmlexception de) {}
        List<String> wostr = new List<String>();
        wostr.add(a.id);
        GoogleGeoCode4Tech.go( wostr );
        
        //GoogleGeoCode4WO.dumpResponse( new HttpResponse() );
    }
    
     public static testmethod void testgeocode() { 
        
        xmldom dom = GoogleGeoCode4Tech.geocode('1600 Amphitheatre Parkway, Mountain View, CA');     
    
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
        //dom = GoogleGeoCode4WO.geocode('1600 a Parkway,  View, GA');
        //system.debug ( 'code is '   +dom.root.getValue('code'));
        //system.assert ( dom.root.getValue('code') == '602' , ' unexpected return code');
        
    }
    
    public static testmethod void t3() { 
        string test_resp = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>Elm St. Chico CA null</name><Status><code>602</code><request>geocode</request></Status></Response></kml>';
        string test_resp2 = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0" ><Response ><name >1600 Amphitheatre Parkway, Mountain View, CA</name><Status ><code >200</code><request >geocode</request></Status><Placemark id="p1" ><address >1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA</address><Point ><coordinates >-122.085121,37.423088,0</coordinates></Point></Placemark></Response></kml>';
        SVMXC__Service_Group_Members__c a = new SVMXC__Service_Group_Members__c() ; 
        GoogleGeoCode4Tech.processGeocodeDom( new xmldom( test_resp) ,a);  
        GoogleGeoCode4Tech.processGeocodeDom( new xmldom( test_resp2) ,a);  
    } 
     public static testmethod void t4() { 
        GoogleGeoCode4Tech geo = new GoogleGeoCode4Tech();      
        SVMXC__Service_Group_Members__c a = new SVMXC__Service_Group_Members__c() ;   
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        GoogleGeoCode4Tech geo2 = new GoogleGeoCode4Tech(sc); 
    } 
    
}