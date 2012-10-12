@isTest
private class SVMX_VF_PartsRequest_UT {

     public static testmethod void test()
    {
        SVMXC__Site__c locationone=new SVMXC__Site__c();
        locationone.Name = 'Test location';
        locationone.SVMXC__City__c ='Test City';
        locationone.SVMXC__Country__c = 'Test Country';
        locationone.SVMXC__State__c = 'Test State';
        locationone.SVMXC__Zip__c = '11111111';
        locationone.SVMXC__Stocking_Location__c = true;
        insert locationone;
        SVMXC__Site__c locationtwo=new SVMXC__Site__c();
        locationtwo.Name = 'Test location two';
        locationtwo.SVMXC__City__c ='Test City two';
        locationtwo.SVMXC__Country__c = 'Test Country two';
        locationtwo.SVMXC__State__c = 'Test State two';
        locationtwo.SVMXC__Zip__c = '11111112';
        locationtwo.SVMXC__Stocking_Location__c = true;
        insert locationtwo;
        list<SVMXC__Parts_Request__c> oRSO= new list<SVMXC__Parts_Request__c>();
        SVMXC__Parts_Request__c o1 = new SVMXC__Parts_Request__c();
        o1.SVMXC__Requested_From__c=locationone.id;
        o1.SVMXC__Required_At_Location__c = locationtwo.id;
        
        insert o1;
        oRSO.add(o1);
        PageReference pageRef4 = new PageReference('Page.SVMX_VF_PartsRequest?RecordId='+o1.Id+'&DispTYP=xls');
        Test.setCurrentPage(pageRef4);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
        SVMX_VF_PartsRequest controller2 = new SVMX_VF_PartsRequest(controller1);
        controller2.getstrDispTyp();
        controller2.strDispTyp = 'pdf';
        controller2.getstrDispTyp();
        controller2.getcontype();
        
        controller2.getREPTAG001();
        controller2.getREPTAG002();
        
       
        controller2.svmxTagList.clear();
        controller2.getREPTAG001();
        controller2.getREPTAG002();
        
        
        
        
        Date d;
        DateTime dt;
        controller2.getFormattedDate(System.today());
        controller2.getFormattedDate(System.now());
        controller2.getFormattedDate(d);
        controller2.getFormattedDate(d);
        
        SVMX_VF_PartsRequest.getFieldList(Schema.SObjectType.SVMXC__Parts_Request_Line__c.fields.getMap(), true);
        SVMX_VF_PartsRequest.getFieldList(Schema.SObjectType.SVMXC__Parts_Request_Line__c.fields.getMap(), false);
        SVMX_VF_PartsRequest.Wraper w = new SVMX_VF_PartsRequest.Wraper( new SVMXC__Parts_Request__c(), new list<SVMXC__Parts_Request_Line__c>() );
        w.getRMADate();
        w.getsObj();
        w.getlstsObj();
        controller2.lstParts_Reqest.clear();
        controller2.lstParts_Reqest.addAll(oRSO);
        controller2.getPARTSRequest2();
        

    }
    public static testmethod void test2()
    {
        string d = string.valueOf(math.random());
        
        list<SVMXC__Parts_Request__c> lstRMASO= new list<SVMXC__Parts_Request__c>();
        SVMXC__Parts_Request__c o1 = new SVMXC__Parts_Request__c();
        SVMXC__Parts_Request__c o2 = new SVMXC__Parts_Request__c();
        lstRMASO.add(o1);
        lstRMASO.add(o2);
        //insert lstRMASO;
        //SVMXC__Parts_Request_Line__c oL1 = new SVMXC__Parts_Request_Line__c( SVMXC__RMA_Shipment_Order__c = o1.Id);
       /*
        insert oL1;
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
        
        PageReference pageRef = new PageReference('Page.SVMX_VF_PartsRequest?d='+d+'&DispTYP=doc');
        Test.setCurrentPage(pageRef);
        SVMX_VF_PartsRequest controller2 = new SVMX_VF_PartsRequest();
        controller2.lstParts_Reqest.clear();
        controller2.lstParts_Reqest.addAll(lstRMASO);
        controller2.getPARTSRequest2();
        */
    }
}