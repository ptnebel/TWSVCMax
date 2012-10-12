public class SVMX_VF_Service_Contract_UT 
{ 
    public static testmethod void test()
    { 
        list<SVMXC__Service_Contract__c> lstSerCont= new list<SVMXC__Service_Contract__c>();
        SVMXC__Service_Contract__c o1 = new SVMXC__Service_Contract__c();
        SVMXC__Service_Contract__c o2 = new SVMXC__Service_Contract__c();
        lstSerCont.add(o1);
        lstSerCont.add(o2);
        insert lstSerCont;
        SVMXC__Service_Contract_Products__c oCP1 = new SVMXC__Service_Contract_Products__c(SVMXC__Service_Contract__c = o1.Id); 
        SVMXC__Service_Contract_Services__c oCS1 = new SVMXC__Service_Contract_Services__c(SVMXC__Service_Contract__c = o1.Id);
        SVMXC__Service_Contract_Sites__c oCL1 = new SVMXC__Service_Contract_Sites__c(SVMXC__Service_Contract__c = o1.Id);
        SVMXC__Service_Contract_Contacts__c oCC1 = new SVMXC__Service_Contract_Contacts__c(SVMXC__Service_Contract__c = o1.Id);
        
        SVMXC__Service_Contract_Products__c oCP2 = new SVMXC__Service_Contract_Products__c(SVMXC__Service_Contract__c = o1.Id); 
        SVMXC__Service_Contract_Services__c oCS2 = new SVMXC__Service_Contract_Services__c(SVMXC__Service_Contract__c = o1.Id);
        SVMXC__Service_Contract_Sites__c oCL2 = new SVMXC__Service_Contract_Sites__c(SVMXC__Service_Contract__c = o1.Id);
        SVMXC__Service_Contract_Contacts__c oCC2 = new SVMXC__Service_Contract_Contacts__c(SVMXC__Service_Contract__c = o1.Id);
        
        List<SVMXC__Service_Contract_Products__c> lstPD2 = new List<SVMXC__Service_Contract_Products__c>();
        List<SVMXC__Service_Contract_Services__c> lstIS2 = new List<SVMXC__Service_Contract_Services__c>();
        List<SVMXC__Service_Contract_Sites__c> lstCL2 = new List<SVMXC__Service_Contract_Sites__c>();
        List<SVMXC__Service_Contract_Contacts__c> lstEC2 = new List<SVMXC__Service_Contract_Contacts__c>(); 
        lstPD2.add(oCP1);
        lstIS2.add(oCS1);
        lstCL2.add(oCL1);
        lstEC2.add(oCC1);
        lstPD2.add(oCP2);
        lstIS2.add(oCS2);
        lstCL2.add(oCL2);
        lstEC2.add(oCC2);
                
        insert lstPD2;
        insert lstIS2;
        insert lstCL2;
        insert lstEC2;
        
        PageReference pageRef4 = new PageReference('Page.SVMX_VF_Service_Contract?RecordId='+o1.Id+'&DispTYP=xls');
        Test.setCurrentPage(pageRef4);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
        SVMX_VF_Service_Contract controller2 = new SVMX_VF_Service_Contract(controller1);
        controller2.lstSerContract.clear();
        controller2.lstSerContract.addAll(lstSerCont);
        controller2.getSVContract();
        
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
        controller2.getFormattedDate(dt);
        
        SVMX_VF_Service_Contract.getFieldList(Schema.SObjectType.SVMXC__Service_Contract_Products__c.fields.getMap(), true);
        SVMX_VF_Service_Contract.getFieldList(Schema.SObjectType.SVMXC__Service_Contract_Products__c.fields.getMap(), false);
        SVMX_VF_Service_Contract.Wraper w = new SVMX_VF_Service_Contract.Wraper( new SVMXC__Service_Contract__c(), new list<SVMXC__Service_Contract_Products__c>(), new list<SVMXC__Service_Contract_Services__c>(), new list<SVMXC__Service_Contract_Sites__c>(), new list<SVMXC__Service_Contract_Contacts__c>()); 
        w.getsObj();
        w.getSVCProductDetails();
        w.getSVCIncludedServices();
        w.getSVCCoverdLocation();
        w.getSVCEntitledContacts();
        w.getStartDt();
        w.getEndDt();
        w.getRenewDt();
        w.getRenNum();
        

    }
    public static testmethod void test2()
    {
        string d = string.valueOf(math.random());
        
        list<SVMXC__Service_Contract__c> lstRMASO= new list<SVMXC__Service_Contract__c>();
        SVMXC__Service_Contract__c o1 = new SVMXC__Service_Contract__c();
        SVMXC__Service_Contract__c o2 = new SVMXC__Service_Contract__c();
        lstRMASO.add(o1);
        lstRMASO.add(o2);
        insert lstRMASO;
        SVMXC__Service_Contract_Products__c oL1 = new SVMXC__Service_Contract_Products__c( SVMXC__Service_Contract__c = o1.Id);
        SVMXC__Service_Contract_Products__c oL2 = new SVMXC__Service_Contract_Products__c( SVMXC__Service_Contract__c = o2.Id);
        insert oL1;
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
        
        PageReference pageRef = new PageReference('Page.SVMX_VF_Service_Contract?d='+d+'&DispTYP=doc');
        Test.setCurrentPage(pageRef);
        SVMX_VF_Service_Contract controller2 = new SVMX_VF_Service_Contract(null);
    }
}