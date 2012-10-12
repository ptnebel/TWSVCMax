public class COMM_Utils_Reports_UT {

    public static testmethod void test()
    {
        
        string strUserID = UserInfo.getUserId();
        string strSessionID = UserInfo.getSessionId();
        list<SVMXC__RMA_Shipment_Order__c> lstRMA = new list<SVMXC__RMA_Shipment_Order__c>();
        SVMXC__RMA_Shipment_Order__c o1 = new SVMXC__RMA_Shipment_Order__c();
        lstRMA.add(o1);
        insert lstRMA;
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>();
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c ( SVMXC__Object_Id__c =o1.Id, SVMXC__Salesforce_Session_ID__c ='ServiceMax', SVMXC__User__c = strUserID);
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c ( SVMXC__Object_Id__c =o1.Id, SVMXC__Salesforce_Session_ID__c = strSessionID, SVMXC__User__c = strUserID);
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
                
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(lstRMA);
        setController.setselected(lstRMA);
        
        COMM_Utils_Reports controller = new COMM_Utils_Reports();
        controller.getServiceMaxList(setController, 'SVMXC.RMA_Shipment_Order.Shipment', strUserID, strSessionID);
       // controller.getSelectTempPage(lstSL, 'SVMXC.RMA_Shipment_Order.Shipment',true, '' );
      //  controller.getSelectTempPage(lstSL, 'SVMXC.RMA_Shipment_Order.Shipment',false, oSL1.Id );
        
        COMM_Utils_Reports.SVMX_ListCleanUp(strUserID, strSessionID);
        COMM_Utils_Reports.getcontype('pdf');
        COMM_Utils_Reports.getcontype('xls');
        COMM_Utils_Reports.getcontype('doc');
        
        Date d;
        DateTime dt;
        COMM_Utils_Reports.getFormattedDate(System.today());
        COMM_Utils_Reports.getFormattedDate(System.now());
        COMM_Utils_Reports.getFormattedDate(d);
        COMM_Utils_Reports.getFormattedDate(dt);
    }
}