public class SVMX_VF_Work_Order_Int_UT 
{
	public static testmethod void test()
	{
		PageReference pageRef = new PageReference('Page.SVMX_VF_Work_Order_Int');
        Test.setCurrentPage(pageRef);
		
		list<SVMXC__Service_Order__c> lstSC= new list<SVMXC__Service_Order__c>();
		SVMXC__Service_Order__c o1 = new SVMXC__Service_Order__c();
		lstSC.add(o1);
		insert lstSC;
		ApexPages.StandardSetController setController = new ApexPages.StandardSetController(lstSC);
		setController.setselected(lstSC);
		SVMX_VF_Work_Order_Int controller = new SVMX_VF_Work_Order_Int(setController);
		
		controller.insertRec();
		controller.getisInsert(); 
		
		SVMXC__Service_Order__c o2 = new SVMXC__Service_Order__c();
		insert o2;
		lstSC.add(o2);
		PageReference pageRef2 = new PageReference('Page.SVMX_VF_Work_Order_Int');
        Test.setCurrentPage(pageRef2);
		ApexPages.StandardSetController setController2 = new ApexPages.StandardSetController(lstSC);
		setController2.setselected(lstSC);
		SVMX_VF_Work_Order_Int controller2 = new SVMX_VF_Work_Order_Int(setController2);
		
		ApexPages.StandardSetController setController3 = new ApexPages.StandardSetController(lstSC);
		SVMX_VF_Work_Order_Int controller3 = new SVMX_VF_Work_Order_Int(setController3);
		controller3.insertRec();
		
		
	}
}