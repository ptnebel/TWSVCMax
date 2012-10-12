public class SVMX_VF_Parts_Order_Int_UT 
{
	public static testmethod void test()
	{
		PageReference pageRef = new PageReference('Page.SVMX_VF_Parts_Order_Int');
        Test.setCurrentPage(pageRef);
		
		list<SVMXC__RMA_Shipment_Order__c> oRSO= new list<SVMXC__RMA_Shipment_Order__c>();
		SVMXC__RMA_Shipment_Order__c o1 = new SVMXC__RMA_Shipment_Order__c();
		oRSO.add(o1);
		insert oRSO;
		ApexPages.StandardSetController setController = new ApexPages.StandardSetController(oRSO);
		setController.setselected(oRSO);
		SVMX_VF_Parts_Order_Int controller = new SVMX_VF_Parts_Order_Int(setController);
		
		controller.insertRec();
		controller.getisInsert(); 
		
		SVMXC__RMA_Shipment_Order__c o2 = new SVMXC__RMA_Shipment_Order__c();
		insert o2;
		oRSO.add(o2);
		PageReference pageRef2 = new PageReference('Page.SVMX_VF_Parts_Order_Int');
        Test.setCurrentPage(pageRef2);
		ApexPages.StandardSetController setController2 = new ApexPages.StandardSetController(oRSO);
		setController2.setselected(oRSO);
		SVMX_VF_Parts_Order_Int controller2 = new SVMX_VF_Parts_Order_Int(setController2);
		
		ApexPages.StandardSetController setController3 = new ApexPages.StandardSetController(oRSO);
		SVMX_VF_Parts_Order_Int controller3 = new SVMX_VF_Parts_Order_Int(setController3);
		controller3.insertRec();
		
		
	}
}