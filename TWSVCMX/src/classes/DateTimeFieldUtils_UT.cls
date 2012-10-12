@isTest
private class DateTimeFieldUtils_UT {
    static testMethod void DateTimeFieldUtilsUnitTest() 
    {/*
        SVMXC__Service_Order__c so=new SVMXC__Service_Order__c();
         datetime dt = datetime.now().addDays(-1);
        so.SVMXC__Actual_Initial_Response__c =dt;
        insert so;*/
        Account account = new Account(
                                        Name ='Account',
                                        ShippingStreet='ABC',
                                        ShippingCity='PQR ',
                                        ShippingState = 'XYZ',
                                        ShippingPostalCode='111',
                                        ShippingCountry='XYZ',
                                        BillingStreet='ABC',
                                        BillingCity='PQR ',
                                        BillingState = 'XYZ',
                                        BillingPostalCode='111',
                                        BillingCountry='XYZ'
                                        ); 
        insert account;
 
 
        Contact contact = new Contact(LastName='Last',AccountId =account.Id,Email='svmxmailfortest@gmail.com');
        insert contact;
 
       
        Case case1 = new Case(Status ='New', Priority = 'Medium', 
                                        Origin = 'Email',                                        
                                        CurrencyIsoCode = 'USD',                                            
                                        ContactId =contact.Id,
                                        AccountId=account.Id                                         
                                        ); 
        
        
        insert case1; 
       
        test.startTest();
       
        ApexPages.currentPage().getParameters().put('ObjId', case1.id);
        ApexPages.currentPage().getParameters().put('FieldAPIName', 'SVMXC__Actual_Initial_Response__c');
        ApexPages.currentPage().getParameters().put('ObjAPIName', 'Case');
		DateTimeFieldUtils dtf=new DateTimeFieldUtils();
		dtf.updateObject();
		ApexPages.currentPage().getParameters().put('ObjId', contact.id);
        ApexPages.currentPage().getParameters().put('FieldAPIName', 'SVMXC__Actual_Initial_Response__c');
        ApexPages.currentPage().getParameters().put('ObjAPIName', 'Case');
        DateTimeFieldUtils dtf2=new DateTimeFieldUtils();
        dtf2.updateObject();
        
        test.stopTest();
    }

}