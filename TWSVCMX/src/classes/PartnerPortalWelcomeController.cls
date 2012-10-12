public with sharing class PartnerPortalWelcomeController {
    public String UserId = UserInfo.getUserId();
    public String UserName = UserInfo.getName();
    User u = [Select id,contactId,Contact.AccountId from User where id = :UserId];
    public String acctId = u.Contact.AccountId;
    public String AccountId = u.Contact.AccountId;
    
    public PartnerPortalWelcomeController() {
    	initRecentCases();
    	initInstalledProducts();    	
    }
    
    public List<Case> RecentCases; 
    public void initRecentCases() {        
    	RecentCases = [select id,CaseNumber,Subject,Status,LastModifiedDate from Case order by LastModifiedDate desc limit 5];
    }
    public Boolean ShowRecentCases {
        get { return ShowRecentCases; }
        set { ShowRecentCases = value; }   
    }
    
    public String RecentCasesMessage {
        get { return RecentCasesMessage; }
        set { RecentCasesMessage = value; }    
    }
    public list<Case> getRecentCases() {
        return RecentCases;
    }
    
    public List<SVMXC__Installed_Product__c> installedProducts {get;set;}
    public void initInstalledProducts() {
    	installedProducts = [Select SVMXC__Serial_Lot_Number__c, SVMXC__Product_Name__c, SVMXC__Date_Installed__c, Name From SVMXC__Installed_Product__c Order by LastModifiedDate limit 5];
    }
    
    public static testmethod void tPartnerPage(){
    	PartnerPortalWelcomeController pp = new PartnerPortalWelcomeController(); 
    	pp.getRecentCases();
    }
}