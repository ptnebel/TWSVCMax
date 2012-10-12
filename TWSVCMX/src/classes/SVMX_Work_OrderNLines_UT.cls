public class SVMX_Work_OrderNLines_UT {
    static testMethod void SVMX_Work_OrderNLines_Test()
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
        
        
        List<SVMXC__Service_Order_Line__c>  WOL = new List<SVMXC__Service_Order_Line__c>();
        WOL.add(svol);
        
        //Calling Class methods
        SVMX_Work_OrderNLines classInst = new SVMX_Work_OrderNLines();
        classInst.Assign(SVO, WOL);
        //SVMX_Work_OrderNLines classInst2 = new SVMX_Work_OrderNLines(SVO, WOL);
        
        WOL = classInst.getLines();
        
        SVMX_Work_Order classInst4 = new SVMX_Work_Order();
        classInst4 = classInst.getSVOHeader();
        
    }
}