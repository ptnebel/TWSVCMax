public with sharing class SVMX_VF_Parts_Order_Int
{
    public list<SVMXC__ServiceMax_List__c> tlst= new list<SVMXC__ServiceMax_List__c>();
    string ObjName='SVMXC.RMA_Shipment_Order.Shipment';
    string sId;
    string d;
    boolean isMultiRecord;
    string strUserID = UserInfo.getUserId();
    string strSessionID = UserInfo.getSessionId();
    public boolean isInsert = true;
    public boolean getisInsert() {return this.isInsert;}
    public String retURL = System.currentPageReference().getParameters().get('retURL');
    SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
    public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('COMMSELTEMPLATE');
    public Boolean stopProcess=false;
    
    public SVMX_VF_Parts_Order_Int(ApexPages.StandardSetController controller)
    {
        tlst.clear();
        if(controller.getselected().size()==0){
        	stopProcess=true;
        	ButtonDisp = true;
        	ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, getREPTAG009(),getREPTAG009())); 
        }
        if (controller.getselected().size() > 0)
        {
            if (controller.getselected().size() == 1)
            {
                sId=controller.getselected()[0].Id;
                isMultiRecord = false;
            }
            else if(controller.getselected().size() > 1)
            {
                COMM_Utils_Reports oUtilRep = new COMM_Utils_Reports();
                tlst = oUtilRep.getServiceMaxList(controller, ObjName, strUserID, strSessionID);  
                isMultiRecord = true;
            }
            ButtonDisp =false;
        }
    }
    public Boolean ButtonDisp{get;set;}
    public pageReference SVMX_Back(){
    		pageReference p=new pageReference(retURL);
	        p.setRedirect(true);
	        return p;
    }

    public pageReference insertRec()
    {
       
        isInsert = false;
        if(!stopProcess){
        	COMM_Utils_Reports oUtilRep = new COMM_Utils_Reports();
	        pageReference pagRef = oUtilRep.getSelectTempPage(tlst, ObjName, isMultiRecord, sId, retURL);
	        COMM_Utils_Reports.SVMX_ListCleanUp(strUserID, strSessionID);
	        return pagRef;
        	
        }
        else {
	        
	        return null;
        }
    }
     public String getREPTAG009(){ return svmxTagList.containsKey('REPTAG009')?svmxTagList.get('REPTAG009') : '';}
     public String getREPTAG010(){ return svmxTagList.containsKey('REPTAG010')?svmxTagList.get('REPTAG010') : '';}
}