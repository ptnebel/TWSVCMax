public class SVMX_VF_ServiceQuoteFromEstimates_UT {
static testMethod void SVMX_VF_ServiceQuoteFromEstimates_Test()
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
                                            ContactId =ct.Id,
                                            AccountId=ac.Id
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
         
         //create SVO Lines - Estimate
        RecordType rtSvoLine = [SELECT Id FROM RecordType WHERE SobjectType = 'SVMXC__Service_Order_Line__c' AND Name = 'Estimate' Limit 1];
        SVMXC__Service_Order_Line__c svol = new SVMXC__Service_Order_Line__c(
                                                SVMXC__Service_Order__c = svo.id,
                                                SVMXC__Product__c = pr.id,
                                                SVMXC__Line_Type__c = 'Parts',
                                                SVMXC__Estimated_Quantity2__c = 2,
                                                SVMXC__Estimated_Price2__c =2,
                                                SVMXC__Actual_Quantity2__c  =2,
                                                RecordTypeId = rtSvoLine.id
                                        );
        insert svol; 
        
        
        ApexPages.StandardController stdcontroller = new ApexPages.standardController(svo);

        
        //Test converage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.SVMX_VF_ServiceQuoteFromEstimates;
        pageRef.getParameters().put('id',svo.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_VF_ServiceQuoteFromEstimates myPageCon = new SVMX_VF_ServiceQuoteFromEstimates(stdcontroller);
        
        //try calling methods/properties of the controller in all possible scenarios
        // to get the best coverage.
        SVMXC__Service_Order__c pWO = myPageCon.getSVQFMEstimate();
    
        List<SVMXC__Service_Order_Line__c> pWOLines =  myPageCon.getSVQuoteDetails();
     
        String strWOdt =  myPageCon.getSVQEDate();
        String strCurrDt =  myPageCon.getCurrentDate();
        
        Date dat = System.today();
        String strDt =  myPageCon.getFormattedDate(dat);
        String str1 =  myPageCon.getcontype();
        String str2 =  myPageCon.getrender();  
       
         myPageCon.getREPTAG001();
         myPageCon.getREPTAG003();
         myPageCon.getREPTAG004();
         
         myPageCon.svmxTagList.clear();
         
         myPageCon.getREPTAG001();
         myPageCon.getREPTAG003();
         myPageCon.getREPTAG004();

      
  
    
      }
}