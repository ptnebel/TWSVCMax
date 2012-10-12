public with sharing class TW_WS_Utils {

public static  ThingWorx_Settings__c TWLogon {get;set; }
public static  string									TWUrl {get;set;}


public static string generateResponse (boolean bSuccess, string sErrorMsg, Id sfdcId){
 JSONGenerator gen = JSON.createGenerator(true);
	gen.writeStartObject();
	gen.writeBooleanField('Success', bSuccess);
    if (!bSuccess) gen.writeStringField('Error', sErrorMsg);
    if (bSuccess)		gen.writeStringField('sfdcId', sfdcId);
    system.debug ('response~~~'+gen.getAsString());
  	return  gen.getAsString()  ;
}


public static Dom.Document invokeCallout( HttpRequest req){
	Http h = new Http();
     //Invoke Web Service
     HttpResponse res = h.send(req);
     Dom.Document doc = res.getBodyDocument(); 
     system.debug(doc);
     return doc;
}

public static string invokeCalloutString( HttpRequest req){
	Http h = new Http();
	
     //Invoke Web Service
     HttpResponse res = h.send(req);
     string s =  res.getBody(); 
     system.debug(s);
     return s;
}
	public static void loginToTw(){
		HttpRequest req = TW_WS_Utils.generateRequest('Things','AthenticationCallback');
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
	    gen.writeEndObject();
	      	
	     	string sBodyString= gen.getAsString();
			req.setBody(sBodyString);
	     	system.debug(req.getHeader('Authorization'));
		string s = TW_WS_Utils.invokeCalloutString(req);
		system.debug(s);
	}

	public static HttpRequest generateRequest(string objectType, string serviceType){
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
	     	req.setTimeout(60000);    	
			TWLogon = ThingWorx_Settings__c.getOrgDefaults();
			TWUrl = TWLogon.EndPoint__c;
			TWUrl +='/Thingworx/';
			TWUrl+=objectType;
			TWUrl+='/SalesForceConnect/Services/';
			TWUrl+=serviceType;
			TWUrl+='?method=post';
			TWUrl+='&userid='+twLogon.UserName__c;
			TWUrl+='&password='+twLogon.Password__c;
			req.setEndpoint(TWUrl);
			return req;
	}
}