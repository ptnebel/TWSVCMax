public class SVMX_VF_ServiceReport_UT 
{
    public static testmethod void test()
    {
        list<SVMXC__Service_Order__c> oRSO= new list<SVMXC__Service_Order__c>();
        SVMXC__Service_Order__c o1 = new SVMXC__Service_Order__c();
        //insert o1;
        PageReference pageRef4 = new PageReference('Page.SVMX_VF_ServiceReport?RecordId='+o1.Id+'&DispTYP=xls');
        Test.setCurrentPage(pageRef4);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
        SVMX_VF_ServiceReport controller2 = new SVMX_VF_ServiceReport(controller1);
        //controller2.getstrDispTyp();
        controller2.strDispTyp = 'pdf';
        //controller2.getstrDispTyp();
        controller2.getcontype();
        
        //controller2.getREPTAG002();
       
        controller2.svmxTagList.clear();
       
                
        
        SVMX_VF_ServiceReport.getFieldList(Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap(), true);
        SVMX_VF_ServiceReport.getFieldList(Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap(), false);
        SVMX_VF_ServiceReport.Wraper w = new SVMX_VF_ServiceReport.Wraper( new SVMXC__Service_Order__c(), new list<SVMXC__Service_Order_Line__c>(),'a' ); 
        w.getsObj();
        w.getlstsObj();
        w.getWOCreatedDate();
    }
    public static testmethod void test2()
    {
        string d = string.valueOf(math.random());
        
        list<SVMXC__Service_Order__c> lstRMASO= new list<SVMXC__Service_Order__c>();
        SVMXC__Service_Order__c o1 = new SVMXC__Service_Order__c();
        SVMXC__Service_Order__c o2 = new SVMXC__Service_Order__c();
        lstRMASO.add(o1);
        lstRMASO.add(o2);
        //insert lstRMASO;
        SVMXC__Service_Order_Line__c oL1 = new SVMXC__Service_Order_Line__c( SVMXC__Service_Order__c = o1.Id);
        //insert oL1;
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
        
        PageReference pageRef = new PageReference('Page.SVMX_VF_ServiceReport?d='+d+'&DispTYP=doc');
        Test.setCurrentPage(pageRef);
        SVMX_VF_ServiceReport controller2 = new SVMX_VF_ServiceReport(null);
        //controller2.WorkOrder.clear();
        //controller2.WorkOrder.addAll(lstRMASO);
        controller2.getWorkOrders();
        
    }
}