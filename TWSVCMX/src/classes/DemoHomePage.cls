public with sharing class DemoHomePage {
	public User partnerUser = new User();

	public User getPartnerUser(){
		if(partnerUser.id==null){
			partnerUser = [select id,name from User where Profile.Name like '%Partner%'];
		}
		return partnerUser;
	}
	
	static testmethod void DemoHomePageTest() {
		PageReference pageRef = new PageReference('Page.DemoHomePage');
	}
	
	
	public DemoHomePage(){}
	private final ApexPages.StandardController theController;
	public DemoHomePage(ApexPages.StandardController stdController){		
		theController = stdController;
	}
	
	public PageReference LoginAsTech(){		
		User[] techmann = [select id, name from User where Name='Scott Techmann' limit 1];
		if (techmann.size()==0){			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot log into the user Scott Techmann.'));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check that the user exists.'));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check that the user has granted login access.'));
			return null;
		} else {		
			PageReference pageRef = new PageReference('/servlet/servlet.su?oid='+UserInfo.getOrganizationId()+'&suorgadminid='+techmann[0].id+'&retURL=%2Fhome%2Fhome.jsp&targetURL=%2Fhome%2Fhome.jsp');				
			pageRef.setRedirect(true);
			System.debug('pageRef: '+pageRef);
			return pageRef;
		}
	}
	
	public PageReference LoginAsTitaniumUser(){		
		User[] titanium = [select id, name from User where Name='Titanium User' limit 1];
		if (titanium.size()==0){			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot log into the user Titanium User.'));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check that the user exists.'));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check that the user has granted login access.'));
			return null;
		} else {		
			PageReference pageRef = new PageReference('/servlet/servlet.su?oid='+UserInfo.getOrganizationId()+'&suorgadminid='+titanium[0].id+'&retURL=%2Fhome%2Fhome.jsp&targetURL=%2Fhome%2Fhome.jsp');				
			pageRef.setRedirect(true);
			System.debug('pageRef: '+pageRef);
			return pageRef;
		}
	}
	
	public PageReference LoginAsPartnerUser(){		
		User[] partner = [select id, name from User where Profile.Name='ServiceMax Partner User' limit 1];
		if (partner.size()==0){			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot log into the profile ServiceMax Partner User.'));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check that the profile exists.'));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check that the profile has partner portal user setup.'));
			return null;
		} else {		
			PageReference pageRef = new PageReference('/servlet/servlet.su?oid='+UserInfo.getOrganizationId()+'&suportaluserid='+partner[0].id);													
			pageRef.setRedirect(true);			
			System.debug('pageRef: '+pageRef); 
			return pageRef;
		}
	}
}