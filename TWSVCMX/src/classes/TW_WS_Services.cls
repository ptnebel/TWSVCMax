public with sharing class TW_WS_Services {


@Future(callout=true)
public static void createThinginTw_future(Id IpId){
	SVMXC__Installed_Product__c ip = [select id, SVMXC__Company__r.customer_id__c, SVMXC__Product_Name__c, SVMXC__Asset_Tag__c,name from SVMXC__Installed_Product__c where id =:IpId];
	HttpRequest req = generateCreateThingRequest(ip);
	String doc = TW_WS_Utils.invokeCalloutString(req);
	system.debug(doc);
}

//@future
public static void createThinginTw(Id IpId){
	SVMXC__Installed_Product__c ip = [select id, SVMXC__Company__r.customer_id__c, SVMXC__Product_Name__c, SVMXC__Asset_Tag__c,name from SVMXC__Installed_Product__c where id =:IpId];
	HttpRequest req = generateCreateThingRequest(ip);
	String doc = TW_WS_Utils.invokeCalloutString(req);
	system.debug(doc);
}

@Future(callout=true)
public static void createCustomerinTw_future(Id accountId){
	Account a = [select id, name, billingStreet, billingCity, billingPostalCode, billingState, billingCountry from Account where id =:accountId];
	HttpRequest req = generateCreateCustomerRequest(a);
	String doc = TW_WS_Utils.invokeCalloutString(req);
	system.debug(doc);
}

public static void createCustomerinTw(Id accountId){
	Account a = [select id, name, billingStreet, billingCity, billingPostalCode, billingState, billingCountry from Account where id =:accountId];
	HttpRequest req = generateCreateCustomerRequest(a);
	String doc = TW_WS_Utils.invokeCalloutString(req);
	system.debug(doc);
}

public static HttpRequest   generateCreateThingRequest(SVMXC__Installed_Product__c ip){
	    HttpRequest req = TW_WS_Utils.generateRequest('Things','CreateDevice');
            string url = req.getEndpoint();
            
         url+='&jsonValue={';
	   string bodydata='deviceName:'+ip.SVMXC__Asset_Tag__c;
	    bodydata+=',deviceDescription:'+ip.SVMXC__Asset_Tag__c;
	    bodydata+=',customerId:'+ip.SVMXC__Company__c;
	    bodydata+=',serialNo:'+ip.Name;
	    bodydata+=',sfdcId:'+ip.id;
	    bodydata =EncodingUtil.urlEncode(bodydata, 'UTF-8');
		url+=bodyData;
	    url+='}';
	    url+='&thingworx-session=false';
	    req.setEndpoint(url);	
        
		system.debug(req);
		system.debug(req.getBody());
        return req;
}

public static HttpRequest   generateCreateCustomerRequest(Account a){
	    HttpRequest req = TW_WS_Utils.generateRequest('Things','CreateCustomer');
	    string url = req.getEndpoint();
	        url+='&jsonValue={';

	    string bodyData='customerName:'+a.Name;
	    bodyData+=',customerDescription:'+a.Name;
	    bodyData+=',address:'+a.BillingStreet+' '+a.BillingCity+' '+a.BillingState+' '+a.BillingPostalCode;
	    bodyData+=',sfdcId:'+a.Id;
	    bodydata =EncodingUtil.urlEncode(bodydata, 'UTF-8');	     
	    url+=bodydata;
	    url+='}';
	    url+='&thingworx-session=false';
	    req.setEndpoint(url);
    	system.debug(req);
		system.debug(req.getBody());
        return req;
	}	

}