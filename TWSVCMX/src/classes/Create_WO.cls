public with sharing class Create_WO {
  List <SVMXC__Installed_Product__c> iplist = null;
  SVMXC__Service_Order__c svo;
  
  public Create_WO() {
    ID acctId = System.currentPageReference().getParameters().get('aid');
    Account ac = [Select BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
            from Account 
            where Id = :acctId];
    iplist = [Select Id, SVMXC__Product__r.Id from SVMXC__Installed_Product__c 
        Where SVMXC__Company__c = :acctId
          and SVMXC__Status__c = 'Installed'];
    svo = new SVMXC__Service_Order__c();
    svo.SVMXC__Priority__c = 'High';
    svo.SVMXC__Company__c = acctId;
    svo.SVMXC__Component__c = iplist[0].Id;
    svo.SVMXC__Product__c = iplist[0].SVMXC__Product__r.Id;
    svo.SVMXC__Order_Type__c = 'Field Service';
    svo.SVMXC__Order_Status__c = 'Open';
    svo.SVMXC__Problem_Description__c = 'Device reporting multiple system failures. Need quick attention.';
    svo.SVMXC__City__c = ac.BillingCity;
    svo.SVMXC__State__c = ac.BillingState;
    svo.SVMXC__Street__c = ac.BillingStreet;
    svo.SVMXC__Country__c = ac.BillingCountry;
    svo.SVMXC__Zip__c = ac.BillingPostalCode;
    svo.SVMXC__Purpose_of_Visit__c = 'Repair';
    
  }
  
  public PageReference create() {
    insert svo;
    SVMXC__Service_Order__c svo1 = [select Id, name from SVMXC__Service_Order__c where Id = :svo.Id];
    String pref = '/apex/SVMXC__Dcon_DispatchConsole?isdtp=mn&wid=' + svo1.Id + '&wno=' + svo1.Name ;
    return new Pagereference(pref);
  }
  
  public static testmethod void tCreateWO(){
    //Create Account
    Account a = new Account();
    a.Name='Test';
    insert a;
    
    //Create Installed Product
    SVMXC__Installed_Product__c ip = new SVMXC__Installed_Product__c(Name ='Ip1'); 
    ip.SVMXC__Company__c = a.id; ip.SVMXC__Status__c='Installed';
    insert ip;
     
    //Test coverage for the SVMX_VF_ServiceReport visualforce page
    PageReference pageRef = Page.CreateWOfromInstalledProduct;
    pageRef.getParameters().put('aid',a.Id);
    Test.setCurrentPageReference(pageRef);
    Create_WO ncwo = new Create_WO();
  }
}