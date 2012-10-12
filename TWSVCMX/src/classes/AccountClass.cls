public with sharing class AccountClass {
//======================================= Constructor =============================================//    
	String acctId = System.currentPageReference().getParameters().get('id');
	String acctName = System.currentPageReference().getParameters().get('name');	
	public String getAccountName(){ return acctName;} 
	
	List<SVMXC__Service_Contract__c> contracts = new List<SVMXC__Service_Contract__c>();	
	public List<SVMXC__Service_Contract__c> getContracts(){
		ViewContracts(); return contracts;
	}
	List<SVMXC__PM_Plan__c> plans = new List<SVMXC__PM_Plan__c>();	
	public List<SVMXC__PM_Plan__c> getPlans(){
		ViewContracts(); return plans;
	}
    public void ViewContracts() {   
		Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract__c.sObjectType.getDescribe();
	    Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract__c.fields.getMap();
	    List<String> fieldList = getFieldList(fieldMap,true);      
	    String fieldNames = getFieldNamesFromList(fieldList);
	    fieldNames += ', (select id, name, SVMXC__Service_Contract__c, SVMXC__Start_Date__c, SVMXC__Status__c, SVMXC__End_Date__c from SVMXC__PM_Plan__r) ';
		String SOQLDetail = ' SELECT '+fieldNames+' FROM SVMXC__Service_Contract__c where SVMXC__Company__c=\''+acctId+'\' ';        
		contracts = Database.query(SOQLDetail);  
		for(SVMXC__Service_Contract__c c:contracts){
			for(SVMXC__PM_Plan__c p: c.SVMXC__PM_Plan__r){
				plans.add(p);
			}
		}
    } 	    
   
	    
	public PageReference Save(){		
		PageReference page = new PageReference('/'+acctId);
		return page;
	}
	
	public PageReference Cancel(){
		PageReference page = new PageReference('/'+acctId);
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
}