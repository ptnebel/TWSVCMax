public class SVMX_Select_VF_Template_UT 
{ 
    public static testmethod void test()
    {
        list<SVMXC__Service_Order__c> WorkOrder= new list<SVMXC__Service_Order__c>();
        SVMXC__Service_Order__c o1 = new SVMXC__Service_Order__c();
        SVMXC__Service_Order__c o2 = new SVMXC__Service_Order__c();
        SVMXC__Service_Order__c o3 = new SVMXC__Service_Order__c();
        insert o1;
        
        string d = string.valueOf(math.random());
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d,SVMXC__Object_Id__c =o1.Id );
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d,SVMXC__Object_Id__c =o1.Id );
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
        
        WorkOrder.add(o1);
        WorkOrder.add(o2);
        WorkOrder.add(o3);
        upsert WorkOrder;
         
        SVMXC__Service_Order_Line__c oSOL = new SVMXC__Service_Order_Line__c(SVMXC__Service_Order__c = o1.Id );
        insert oSOL;
        
        PageReference pageRef1 = new PageReference('Page.SVMXC.SVMX_Select_VF_Template?id='+o1.Id+'&DispTYP=pdf');
        Test.setCurrentPage(pageRef1);
        SVMX_Select_VF_Template controller2 = new SVMX_Select_VF_Template();
        
        controller2.getd();
        controller2.getisInsert();
        controller2.setstrDispTyp(null);
        controller2.getstrDispTyp();
        controller2.setstrDispTyp('pdf');
        controller2.getstrDispTyp();
        controller2.getstrReportType();
        controller2.getAttachFile();
        controller2.setAttachFile(true);
        controller2.getSId();
        controller2.getList();
        controller2.getMMDetail();
        controller2.getPageName();
        controller2.setPageName('SVMX_Select_VF_Template');
     //   controller2.getallowAttachment();
        controller2.AttachFile = true;
        controller2.strReportType = 'SingleRecord';
        controller2.Generate();
        controller2.Cancel();
        controller2.getREPTAG001();
        controller2.getREPTAG002();
        controller2.getREPTAG003();
        controller2.getREPTAG004();
        controller2.getREPTAG005();
        controller2.getREPTAG006();
        controller2.getREPTAG007();
        controller2.getREPTAG008();
        controller2.svmxTagList.clear();
        controller2.getREPTAG001();
        controller2.getREPTAG002();
        controller2.getREPTAG003();
        controller2.getREPTAG004();
        controller2.getREPTAG005();
        controller2.getREPTAG006();
        controller2.getREPTAG007();
        controller2.getREPTAG008();
        
        
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
        SVMX_Select_VF_Template.getFieldList(fieldMap, false);
        controller2.tlst = lstSL;
        controller2.strReportType = 'MultipalRecord';
        controller2.ObjName = '';
        controller2.getItems();
        controller2.ObjName = 'asdf\'asdf';
        controller2.getItems();

        controller2.ObjName = 'SVMXC.Service_Order';
        controller2.getItems();
        
        PageReference pageRef3 = new PageReference('Page.SVMXC.SVMX_Select_VF_Template?d='+d+'&DispTYP=doc');
        Test.setCurrentPage(pageRef3);
        SVMX_Select_VF_Template controller8 = new SVMX_Select_VF_Template();
        controller8.setPageName('SVMX_VF_ServiceReport');
        controller8.AttachFile = true;
        controller8.strReportType = 'MultipalRecord';
        //controller8.Generate();
        controller8.Cancel();
        
    }

}