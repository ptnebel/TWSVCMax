@RestResource(urlMapping='/Case/Create/*')
global class RESTCaseController {

public static Case c;
public static boolean bSuccess=true;
public static string sErrorMsg;

@HttpPost	
  global static void createNewCase(String thingId, String errorDetails) {
     System.debug('ThingID: '+thingId);
     System.debug('errorDetails: '+errorDetails);
     c= new Case();
     try {
     SVMXC__Installed_Product__c	 ip = [select id, Name, SVMXC__Company__c,SVMXC__Company__r.Name, SVMXC__Site__c from SVMXC__Installed_Product__c where Id =:thingId];
          

    // c.OwnerId = support[0].User__c;
    c.SVMXC__Component__c = ip.id;
    c.SVMXC__Site__c = ip.SVMXC__Site__c;
     c.AccountId = ip.SVMXC__Company__c;
     c.Status = 'Problem';
     c.Subject = c.Status + ' for '+ip.SVMXC__Company__r.Name+' with '+ip.name;
     c.Status = 'Open';
     c.Origin = 'ThingWorx';
     c.Description = errorDetails;
     insert c;
     }
     catch(exception e){
     	sErrorMsg = e.getMessage();
     	bSuccess = false;
     }
     
	 	RestContext.response.responseBody=blob.valueOf(  TW_WS_Utils.generateResponse(bSuccess, sErrorMsg, c.id));
	 	system.debug(RestContext.response.responseBody.toString());
  }
 
}