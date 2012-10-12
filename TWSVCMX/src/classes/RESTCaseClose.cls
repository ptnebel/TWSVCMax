@RestResource(urlMapping='/Case/Close/*')
global class RESTCaseClose {

public static Case c;
public static boolean bSuccess=true;
public static string sErrorMsg;

@httpPost  
    global static void closeCase(String caseId, String sResolution) {
    	try {
    		c = [select id from Case where id =:caseId];
    		c.Status = 'Closed';
    		update c;
    	}
    	catch(exception e){
     		sErrorMsg = e.getMessage();
     		bSuccess = false;
     	}
    	
    	RestContext.response.responseBody=blob.valueOf(  TW_WS_Utils.generateResponse(bSuccess, sErrorMsg, c.id));
    }
}