public class SVMX_VF_ServiceQuote_UT 
{
    public static testmethod void test()
    {
        list<SVMXC__Quote__c> oRSO= new list<SVMXC__Quote__c>();
        SVMXC__Quote__c o1 = new SVMXC__Quote__c();
        insert o1;
        PageReference pageRef4 = new PageReference('Page.SVMX_VF_ServiceQuote?RecordId='+o1.Id+'&DispTYP=xls');
        Test.setCurrentPage(pageRef4);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
        SVMX_VF_ServiceQuote controller2 = new SVMX_VF_ServiceQuote(controller1);
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
        
        SVMX_VF_ServiceQuote.getFieldList(Schema.SObjectType.SVMXC__Quote_Line__c.fields.getMap(), true);
        SVMX_VF_ServiceQuote.getFieldList(Schema.SObjectType.SVMXC__Quote_Line__c.fields.getMap(), false);
        SVMX_VF_ServiceQuote.Wraper w = new SVMX_VF_ServiceQuote.Wraper( new SVMXC__Quote__c(), new list<SVMXC__Quote_Line__c>()); 
        w.getSVQDate();
        w.getValUnll();
        w.getsObj();
        w.getlstsObj();
        

    }
    public static testmethod void test2()
    {
        string d = string.valueOf(math.random());
        
        list<SVMXC__Quote__c> lstRMASO= new list<SVMXC__Quote__c>();
        SVMXC__Quote__c o1 = new SVMXC__Quote__c();
        SVMXC__Quote__c o2 = new SVMXC__Quote__c();
        lstRMASO.add(o1);
        lstRMASO.add(o2);
        insert lstRMASO;
        SVMXC__Quote_Line__c oL1 = new SVMXC__Quote_Line__c( SVMXC__Quote__c = o1.Id);
        insert oL1;
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
        
        PageReference pageRef = new PageReference('Page.SVMX_VF_ServiceQuote?d='+d+'&DispTYP=doc');
        Test.setCurrentPage(pageRef);
        SVMX_VF_ServiceQuote controller2 = new SVMX_VF_ServiceQuote(null);
        controller2.SVQuote.clear();
        controller2.SVQuote.addAll(lstRMASO);
        controller2.getSVQuote();
    }
}