public class SVMX_Work_Order_UT {
    static testMethod void SVMX_Work_Order_Test()
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
        
        //Create Work Order
        SVMXC__Service_Order__c svo = new SVMXC__Service_Order__c (
                                        SVMXC__Case__c = cs.Id ,
                                        SVMXC__Company__c = ac.Id , 
                                        SVMXC__Order_Status__c = 'Open',
                                        SVMXC__Priority__c ='Medium',
                                        SVMXC__Order_Type__c='Field Service'
                                        );
         insert svo;
        
        
        SVMX_Work_Order classInst = new SVMX_Work_Order(svo);
        SVMX_Work_Order classInst2 = new SVMX_Work_Order();
        classInst2.setSVMX_WorkOrder(svo);
        
        SVMXC__Service_Order__c svo2 = classInst2.getSVMX_WorkOrder();
        String strDt2 =  classInst2.getWOCreatedDate(); 
        
        Date dat = System.today();
        String strDt =  classInst2.getFormattedDate(dat); //Sending Date Val
        dat =null;
        String strDt3 =  classInst2.getFormattedDate(dat); //Sending Null Value
        DateTime datTime =  System.now(); 
        String strDt4 =  classInst2.getFormattedDate(datTime); //Sending DateTime Value
        datTime = null;
        String strDt5 =  classInst2.getFormattedDate(datTime); //Sending null Value
        
    }
}