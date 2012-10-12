public with sharing class SVMX_VF_PartsRequest_Int_UT {
	public static testmethod void test()
	{
		PageReference pageRef = new PageReference('Page.SVMX_VF_PartsRequest_Int');
        Test.setCurrentPage(pageRef);
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
		oRSO.add(o1);
		insert oRSO;
		ApexPages.StandardSetController setController = new ApexPages.StandardSetController(oRSO);
		setController.setselected(oRSO);
		SVMX_VF_PartsRequest_Int controller = new SVMX_VF_PartsRequest_Int(setController);
		
		controller.insertRec();
		controller.getisInsert(); 
		
		SVMXC__Parts_Request__c o2 = new SVMXC__Parts_Request__c();
		o2.SVMXC__Requested_From__c=locationone.id;
        o2.SVMXC__Required_At_Location__c = locationtwo.id;
		insert o2;
		oRSO.add(o2);
		PageReference pageRef2 = new PageReference('Page.SVMX_VF_PartsRequest_Int');
        Test.setCurrentPage(pageRef2);
		ApexPages.StandardSetController setController2 = new ApexPages.StandardSetController(oRSO);
		setController2.setselected(oRSO);
		SVMX_VF_PartsRequest_Int controller2 = new SVMX_VF_PartsRequest_Int(setController2);
		
		ApexPages.StandardSetController setController3 = new ApexPages.StandardSetController(oRSO);
		SVMX_VF_PartsRequest_Int controller3 = new SVMX_VF_PartsRequest_Int(setController3);
		controller3.insertRec();
		
		
	}

}