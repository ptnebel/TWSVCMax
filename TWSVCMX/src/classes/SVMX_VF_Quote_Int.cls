public with sharing class SVMX_VF_Quote_Int 
{
	public list<SVMXC__ServiceMax_List__c> tlst= new list<SVMXC__ServiceMax_List__c>();
    string ObjName='SVMXC.Quote';
    string sId;
    string d;
    boolean isMultiRecord;
    string strUserID = UserInfo.getUserId();
    string strSessionID = UserInfo.getSessionId();
    public boolean isInsert = true;
    public boolean getisInsert() {return this.isInsert;}
    public String retURL = System.currentPageReference().getParameters().get('retURL');
    
    public SVMX_VF_Quote_Int(ApexPages.StandardSetController controller)
    {
        tlst.clear();
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
        }
    }

    public pageReference insertRec()
    {
        isInsert = false;
        COMM_Utils_Reports oUtilRep = new COMM_Utils_Reports();
        pageReference pagRef = oUtilRep.getSelectTempPage(tlst, ObjName, isMultiRecord, sId, retURL);
        COMM_Utils_Reports.SVMX_ListCleanUp(strUserID, strSessionID);
        return pagRef;
    }
	

}