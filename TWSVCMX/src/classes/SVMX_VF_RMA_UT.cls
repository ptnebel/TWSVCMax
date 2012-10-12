public class SVMX_VF_RMA_UT {

    public static testmethod void test()
    {
        list<SVMXC__RMA_Shipment_Order__c> oRSO= new list<SVMXC__RMA_Shipment_Order__c>();
        SVMXC__RMA_Shipment_Order__c o1 = new SVMXC__RMA_Shipment_Order__c();
        insert o1;
        PageReference pageRef4 = new PageReference('Page.SVMX_VF_RMA?RecordId='+o1.Id+'&DispTYP=xls');
        Test.setCurrentPage(pageRef4);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
        SVMX_VF_RMA controller2 = new SVMX_VF_RMA(controller1);
        controller2.getstrDispTyp();
        controller2.strDispTyp = 'pdf';
        controller2.getstrDispTyp();
        controller2.getcontype();
        
        controller2.getREPTAG001();
        controller2.getREPTAG002();
        controller2.getREPTAG003();
        controller2.getREPTAG004();
        controller2.getREPTAG005();
        
        
        controller2.svmxTagList.clear();
        controller2.getREPTAG001();
        controller2.getREPTAG002();
        controller2.getREPTAG003();
        controller2.getREPTAG004();
        controller2.getREPTAG005();
        
        
        
        Date d;
        DateTime dt;
        controller2.getFormattedDate(System.today());
        controller2.getFormattedDate(System.now());
        controller2.getFormattedDate(d);
        controller2.getFormattedDate(d);
        
        SVMX_VF_RMA.getFieldList(Schema.SObjectType.SVMXC__RMA_Shipment_Line__c.fields.getMap(), true);
        SVMX_VF_RMA.getFieldList(Schema.SObjectType.SVMXC__RMA_Shipment_Line__c.fields.getMap(), false);
        SVMX_VF_RMA.Wraper w = new SVMX_VF_RMA.Wraper( new SVMXC__RMA_Shipment_Order__c(), new list<SVMXC__RMA_Shipment_Line__c>() ); 
        w.getRMADate();
        w.getsObj();
        w.getlstsObj();
        

    }
    public static testmethod void test2()
    {
        string d = string.valueOf(math.random());
        
        list<SVMXC__RMA_Shipment_Order__c> lstRMASO= new list<SVMXC__RMA_Shipment_Order__c>();
        SVMXC__RMA_Shipment_Order__c o1 = new SVMXC__RMA_Shipment_Order__c();
        SVMXC__RMA_Shipment_Order__c o2 = new SVMXC__RMA_Shipment_Order__c();
        lstRMASO.add(o1);
        lstRMASO.add(o2);
        insert lstRMASO;
        SVMXC__RMA_Shipment_Line__c oL1 = new SVMXC__RMA_Shipment_Line__c( SVMXC__RMA_Shipment_Order__c = o1.Id);
       /*
        insert oL1;
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
        */
        PageReference pageRef = new PageReference('Page.SVMX_VF_RMA?d='+d+'&DispTYP=doc');
        Test.setCurrentPage(pageRef);
        SVMX_VF_RMA controller2 = new SVMX_VF_RMA(null);
        controller2.lstRMA_Shipment.clear();
        controller2.lstRMA_Shipment.addAll(lstRMASO);
        controller2.getRMAShipment2();
    }
}