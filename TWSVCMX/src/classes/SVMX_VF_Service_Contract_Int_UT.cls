public class SVMX_VF_Service_Contract_Int_UT
{

	public static testmethod void test()
	{
		PageReference pageRef = new PageReference('Page.SVMX_VF_Service_Contract_Int');
        Test.setCurrentPage(pageRef);
		
		list<SVMXC__Service_Contract__c> oSC= new list<SVMXC__Service_Contract__c>();
		SVMXC__Service_Contract__c o1 = new SVMXC__Service_Contract__c();
		oSC.add(o1);
		insert oSC;
		ApexPages.StandardSetController setController = new ApexPages.StandardSetController(oSC);
		setController.setselected(oSC);
		SVMX_VF_Service_Contract_Int controller = new SVMX_VF_Service_Contract_Int(setController);
		
		controller.insertRec();
		controller.getisInsert(); 
		
		SVMXC__Service_Contract__c o2 = new SVMXC__Service_Contract__c();
		insert o2;
		oSC.add(o2);
		PageReference pageRef2 = new PageReference('Page.SVMX_VF_Service_Contract_Int');
        Test.setCurrentPage(pageRef2);
		ApexPages.StandardSetController setController2 = new ApexPages.StandardSetController(oSC);
		setController2.setselected(oSC);
		SVMX_VF_Service_Contract_Int controller2 = new SVMX_VF_Service_Contract_Int(setController2);
		
		ApexPages.StandardSetController setController3 = new ApexPages.StandardSetController(oSC);
		SVMX_VF_Service_Contract_Int controller3 = new SVMX_VF_Service_Contract_Int(setController3);
		controller3.insertRec();
		
		
	}
}