public class SVMX_VF_ServiceContract_UT {
static testMethod void SVMX_VF_ServiceContract_Test()
    { 
        //Create Account
        Account ac = new Account(
                                        Name ='Account',
                                        ShippingStreet='ABC',
                                        ShippingCity='PQR ',
                                        ShippingState = 'XYZ',
                                        ShippingPostalCode='111',
                                        ShippingCountry='XYZ'
                                        ); 
        insert ac;    
        //Create Contact
        Contact  ct = new Contact(LastName='Last',AccountId =ac.Id); 
        insert ct;      
        //Create Case    
        Case cs = new Case(Status ='New', Priority = 'Medium', 
                                            Origin = 'Email', 
                                            //SVMX_Serial_Number__c ='123',
                                            //CurrencyIsoCode = 'USD',                                          
                                            AccountId=ac.Id,
                                            ContactId =ct.Id
                                            ); 
        insert cs;      
        //Create Product
        Product2 pr = new Product2 (
                                            Name ='Prod',
                                            ProductCode='Prod',
                                            //CurrencyIsoCode = 'USD', 
                                            SVMXC__Inherit_Parent_Warranty__c =True 
                                            ); 
        insert pr;   
        
        //Create Work Order
        SVMXC__Service_Order__c svo = new SVMXC__Service_Order__c (
                                        SVMXC__Case__c = cs.Id ,
                                        SVMXC__Company__c = ac.Id , 
                                        SVMXC__Order_Status__c = 'Open',
                                        SVMXC__Priority__c ='Medium',
                                        SVMXC__Order_Type__c='Field Service'
                                        );
         insert svo;
         
         //Create Service Contract  
         SVMXC__Service_Contract__c sc = new SVMXC__Service_Contract__c (
                                        Name = 'Test SC',
                                        SVMXC__Company__c = ac.Id,
                                        SVMXC__Active__c = true,
                                        SVMXC__Start_Date__c = System.today(),
                                        SVMXC__End_Date__c = System.today(),
                                        SVMXC__Renewal_Number__c =2
                                        );
         insert sc;
         //Create Service Contract Line
         SVMXC__Service_Contract_Products__c scLine = new SVMXC__Service_Contract_Products__c (
                                        SVMXC__Product__c = pr.Id,
                                        SVMXC__Service_Contract__c = sc.id
                                        );
         insert scLine;
         
        //Test converage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.SVMX_VF_ServiceContract;
        pageRef.getParameters().put('id',sc.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_VF_ServiceContract myPageCon = new SVMX_VF_ServiceContract();
        
        //try calling methods/properties of the controller in all possible scenarios
        // to get the best coverage.
        SVMXC__Service_Contract__c p = myPageCon.getSVContract();
    
        List<SVMXC__Service_Contract_Products__c> pLines =  myPageCon.getSVCProductDetails();
        List<SVMXC__Service_Contract_Services__c> conlines = myPageCon.getSVCIncludedServices();
        List<SVMXC__Service_Contract_Sites__c> conloca = myPageCon.getSVCCoverdLocation();
        List<SVMXC__Service_Contract_Contacts__c> contacts = myPageCon.getSVCEntitledContacts();
        
        String strSCdt =  myPageCon.getSVCDate();
        String strCurrDt =  myPageCon.getCurrentDate();
        
        Date dat = System.today();
        String strDt =  myPageCon.getFormattedDate(dat);
        Integer intNum = myPageCon.getRenNum();
        String str1 = myPageCon.getStartDt();
        String str2 = myPageCon.getEndDt();
        String str3 = myPageCon.getRenewDt();
        String str4 = myPageCon.getcontype();
        String str5 = myPageCon.getrender();
            
    }
}