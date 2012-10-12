public class COMM_Utils_Reports 
{
    public COMM_Utils_Reports()
    {
    }
    
    public list<SVMXC__ServiceMax_List__c> getServiceMaxList(apexPages.StandardSetController controller, string ObjName, string strUserID, string strSessionID )
    {
        list<SVMXC__ServiceMax_List__c> tlst= new list<SVMXC__ServiceMax_List__c>();
        if (controller.getselected().size() > 0)
        {
            string d = string.valueOf(math.random());
            for (SObject o :controller.getselected())
            {
                SVMXC__ServiceMax_List__c objSVMXLst = new SVMXC__ServiceMax_List__c();
                objSVMXLst.SVMXC__Object_Id__c = o.id;
                objSVMXLst.SVMXC__Source_Location__c = d;
                objSVMXLst.SVMXC__User__c = strUserID ; 
                objSVMXLst.SVMXC__Salesforce_Session_ID__c = strSessionID; 
                tlst.add(objSVMXLst);
            }
        }
        return tlst;
    }
    public static void SVMX_ListCleanUp(string UserId, string Session_ID)
    { 
        list<SVMXC__ServiceMax_List__c> dlst = new list<SVMXC__ServiceMax_List__c>(); 
        for (SVMXC__ServiceMax_List__c o :[select id, SVMXC__Salesforce_Session_ID__c, SVMXC__Source_Location__c from SVMXC__ServiceMax_List__c where SVMXC__User__c = :UserId ])
        {
            if (o.SVMXC__Salesforce_Session_ID__c != Session_ID)
                 dlst.add(o);
        }
        if (dlst.size() > 0 )
            delete dlst;
    }
    public pageReference getSelectTempPage(list<SVMXC__ServiceMax_List__c> tlst, string ObjName, boolean isMultiRecord, string sID, string retURL)
    {
        pageReference pagRef = new pageReference('/apex/SVMX_Select_VF_Template');
        pagRef.getParameters().put('ObjName', ObjName);
        pagRef.getParameters().put('retURL', retURL);
        
        if(isMultiRecord !=null && isMultiRecord && tlst.size() > 0)
        {
            pagRef.getParameters().put('d', tlst[0].SVMXC__Source_Location__c);
            upsert tlst;
        }
        else
        {
            pagRef.getParameters().put('Id', sID);
        }
        pagRef.setRedirect(true);
        return pagRef;
    }
    public static string getcontype(string strDispTyp)
    { 
       String a;
       if(strDispTyp == 'xls')
       {
         a = 'application/vnd.ms-excel#Report.xls';
       }
       else if(strDispTyp == 'doc')
       {
         a = 'application/msword#Report.doc';
       }
       else if(strDispTyp == 'pdf')
       {
         a = 'pdf';
       }
       return a; 
    }
    public static String getFormattedDate(Date dat) 
    {
        return getFormattedDate2(String.ValueOf(dat));     
    }  
    public static String getFormattedDate(DateTime dat) 
    {
        return getFormattedDate2(String.ValueOf(dat));
    } 
    static String getFormattedDate2(String dtVal) 
    {
        String blank='';
        if (dtVal==null)
            return blank;
        String dt;
        String mth;
        String yr;
        yr = dtVal.substring(0,4);
        mth = dtVal.substring(5,7);
        dt = dtVal.substring(8,10);
        dtVal = mth + '/'+ dt + '/'+yr;    
        return dtVal;
    }
}