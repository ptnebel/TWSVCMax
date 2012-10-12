public with sharing class CycleCount {
	public CycleCount(){}
	private final Cycle_Count__c cc; 
	private final ApexPages.StandardController theController;
	public CycleCount(ApexPages.StandardController stdController){
		cc = (Cycle_Count__c)stdController.getRecord();
		theController = stdController;
	} 
	Cycle_Count__c cycle = new Cycle_Count__c();
	public PageReference RequestCycleCount(){ 		
		cycle = [select id, Location__c, Technician__c, Type__c, (select id, Product_Stock__c, Part__c from Cycle_Count_Lines__r) from Cycle_Count__c where id=:cycleid limit 1];
		List<Cycle_Count_Line__c> AlreadyLines = cycle.Cycle_Count_Lines__r; 
		SVMXC__Product_Stock__c[] pstocks = [select id, SVMXC__Quantity2__c, SVMXC__Product__c, SVMXC__Product__r.Name, SVMXC__Product__r.Cycle_Count_Type__c from SVMXC__Product_Stock__c where SVMXC__Location__c=:cycle.Location__c AND SVMXC__Status__c='Available']; 
		List<Cycle_Count_Line__c> Createlines = new List<Cycle_Count_Line__c>();
		for(SVMXC__Product_Stock__c ps: pstocks){
			System.debug('ps.SVMXC__Product__c: '+ps.SVMXC__Product__c);
			System.debug('ps.SVMXC__Product__r.Cycle_Count_Type__c: '+ps.SVMXC__Product__r.Cycle_Count_Type__c);
			System.debug('cycle.Type__c: '+cycle.Type__c);
			Boolean AlreadyAdded = false;
			if(ps.SVMXC__Product__r.Cycle_Count_Type__c==null && cycle.Type__c!=null){
				//skip product cycles with no cycle count type and Cycle Count has a type.
			} else if(ps.SVMXC__Product__r.Cycle_Count_Type__c==cycle.Type__c 
				|| ps.SVMXC__Product__r.Cycle_Count_Type__c.contains(cycle.Type__c)				
				|| cycle.Type__c.contains(ps.SVMXC__Product__r.Cycle_Count_Type__c)
				){ 
				
				Cycle_Count_Line__c line = new Cycle_Count_Line__c(Cycle_Count__c=cycle.id);
				line.Product_Stock__c = ps.id;
				line.Part__c = ps.SVMXC__Product__c;
				line.System_Qty__c = ps.SVMXC__Quantity2__c;
				for(Cycle_Count_Line__c l:AlreadyLines){
					if(l.Product_Stock__c==ps.id) AlreadyAdded=true;
				}
				if(AlreadyAdded==false) Createlines.add(line);
			}
		}
		if(Createlines.size()>0) insert Createlines;		
		return null;
	}	
	 
	String cycleId = System.currentPageReference().getParameters().get('id');
	String cycleName = System.currentPageReference().getParameters().get('name');	
	public String getCycleName(){ 
		return cycleName; 
	}
	
	List<Cycle_Count_Line__c> cyclelines = new List<Cycle_Count_Line__c>();
    public List<Cycle_Count_Line__c> getCycleLines() {
    	ViewCycleLines();
    	return cyclelines; 
    }	
    public void ViewCycleLines() {   
		Schema.DescribeSObjectResult dsoResult = Cycle_Count_Line__c.sObjectType.getDescribe();
	    Map<String, SObjectField> fieldMap = Schema.SObjectType.Cycle_Count_Line__c.fields.getMap();
	    List<String> fieldList = getFieldList(fieldMap,true);      
	    String fieldNames = getFieldNamesFromList(fieldList);
	    System.debug('cycleId: '+cycleId);
		String SOQLDetail = ' SELECT '+fieldNames+' FROM Cycle_Count_Line__c where Cycle_Count__c=\''+cycleId+'\' limit 200';        
		cyclelines = Database.query(SOQLDetail);  
    } 
    	    
    public PageReference QuickSave() { 
		update cyclelines;
		return null;
	}
	
	public PageReference Save(){
		update cyclelines;
		PageReference page = new PageReference('/'+cycleId);
		return page;
	}
	
	public PageReference SaveAndSubmit(){
		update cyclelines;		
		Cycle_Count__c c = [select id from Cycle_Count__c where id=:cyclelines[0].Cycle_Count__c];
		c.Status__c = 'Submitted'; 
		update c;
		PageReference page = new PageReference('/'+cycleId);
		return page;
	}
	
	public PageReference Cancel(){
		PageReference page = new PageReference('/'+cycleId);
		return page;
	}
	
	
	
	
	//Utility Methods used in generating Dynamic SOQL    
    public static List<String> getFieldList( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields){
        List<String> fieldList = new List<String>();        
        //build dynamic list of fieldnames
        for (String fieldKey : fieldMap.keySet()){
            Schema.SObjectField fsObj = fieldMap.get(fieldKey);
            Schema.DescribeFieldResult f = fsObj.getDescribe();
            String fieldName = f.getName();            
            if (selectAllFields){ fieldList.add(fieldName); 
        	} else { if (f.getName()=='Id' || f.isNameField() || f.isCustom()) { fieldList.add(fieldName);}
            }
    	}        
    	return fieldList;
    }
    public static String getFieldNamesFromList(List<String> fieldList){
        String fieldNames = '';
        for (String field : fieldList) {
            if (fieldNames.length()>0) {
                fieldNames += ',';
            }
            fieldNames += field;
        }        
        return fieldNames;
    }
    
    public static testmethod void t1(){
    	SVMXC__Site__c loc = new SVMXC__Site__c(); 
    		loc.Name='Test Location';
    	insert loc;
    	Cycle_Count__c cc = new Cycle_Count__c(); 
    		cc.Location__c = loc.id; 
    	insert cc;
    	//Test coverage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.CycleCountSubmit;
        pageRef.getParameters().put('id',cc.Id);
        pageRef.getParameters().put('name',cc.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        ApexPages.StandardController mc = new Apexpages.Standardcontroller(cc);   
        CycleCount myPageCon = new CycleCount(mc);
        
        //try calling methods/properties of the controller in all possible scenarios
        myPageCon.RequestCycleCount();
        myPageCon.ViewCycleLines();
        myPageCon.Save(); myPageCon.Cancel();
              
    }
    	
}