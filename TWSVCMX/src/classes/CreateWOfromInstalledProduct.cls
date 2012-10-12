public  with sharing class CreateWOfromInstalledProduct{
    
    //========================================= URL Parameters ===============================================//
    String installedproductId = System.currentPageReference().getParameters().get('ipid');
 

    //========================================== Global Declarations =========================================//
    public String SelectedRecordType;
    public List<RecordType> rTypes = new List<RecordType> ();
    public List<SelectOption> rTypeNames = new List<SelectOption>();
    String LineSobjectType = 'SVMXC__Service_Order__c';
    SVMXC__Installed_Product__c InstalledProductHeader;
    Boolean ShowValidData = true;
    Integer count=0;
    

    //=========== Global Variables (with get & set methods) to manage display of Warnings and Errors =========//

    List<String> ErrorMessages = new  List<String> ();
    Boolean ValidRecords = true;
  
    public void AddToErrorsList(String msg) { ErrorMessages.add(msg); }
    public List<String> getErrorsList() {    return ErrorMessages; }  

    public Boolean DisplayBlockLevelMessage = false;
    public Boolean getDisplayBlockLevelMessage(){ return DisplayBlockLevelMessage; }

    

    //=============================== Object to retrive Settings & Translation =============================//
    public SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils();
    public SVMXC.COMM_Utils_ManageSettings settings = new SVMXC.COMM_Utils_ManageSettings();

    //Create instance of UTIL Class
    public SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();



    //===================================== List to store new lines =======================================//
    public List<SVMXC__ServiceMax_Config_Data__c> fieldMapSetting = new List<SVMXC__ServiceMax_Config_Data__c> ();

    
    //======================================== Setting Definition =========================================//
    //public Map<String, String> AllSubModuleSettings = settings.SVMX_getSettingList('WORD004');
    //String SettingValue = AllSubModuleSettings.containsKey('SET001')? AllSubModuleSettings.get('SET001') : ''; //Setting for WO field mapping
    //String SelectRecTypeWOLVFPage = AllSubModuleSettings.containsKey('SET002')?AllSubModuleSettings.get('SET002') : ''; //Setting for wo select record type VF page name
    //String SetngForDefRecType = AllSubModuleSettings.containsKey('SET003')?AllSubModuleSettings.get('SET003') : ''; //Setting for Record Type set to Default
    //String IsHeaderOnly = AllSubModuleSettings.containsKey('SET004')?AllSubModuleSettings.get('SET004') : ''; //Setting for Create header only on creating Work Order from Case
    
    //======================================= Getter & Setter =============================================//
    public String getSelectedRecordType(){ return SelectedRecordType;}
    public void setSelectedRecordType(String RType) { SelectedRecordType = RType;  }

    public Boolean getShowValidData(){ return ShowValidData; } 
    public void setShowValidData(Boolean svd) {ShowValidData=svd; }


    //============================== Method to Display Errors/Warnings ======================================// 
    public void DisplayErrorsNWarnings(){
       
        if( ErrorMessages.size()>0)
            {
                ValidRecords = false;
                DisplayBlockLevelMessage = false;
                for (String msg : ErrorMessages)
                    {
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,getTAG007(),msg)) ;  
                    }
            }   
   
    }


    //======================================= Constructor =============================================//
    public CreateWOFromInstalledProduct(){  //Changed from Std Controller to Custom By GM 29Jan10  :: ApexPages.StandardController controller
        if (installedproductId == null)
        {
            ShowValidData = false;
            AddToErrorsList(getTAG008());       //Source Object Case Id not found
        }
      
        DisplayErrorsNWarnings();

        String SOQLHeader;
/*  	// 
        try{
            fieldMapSetting = settings.SVMX_getFieldMapping( SettingValue); 
            souObjFieldNames = '';
            for(SVMXC__ServiceMax_Config_Data__c fld:fieldMapSetting)
            {
                if (souObjFieldNames.length() > 0) { souObjFieldNames += ', '; }
                souObjFieldNames += fld.SVMXC__Source_Field_Name__c;
            }
            SOQLHeader = '  SELECT '+souObjFieldNames+' FROM SVMXC__Site__c where Id=\''+locationId+'\''; 
            souObjRec = Database.query(SOQLHeader);

            //this is Target Obj Rec : WOrderHeader
            //Populate fields and corresponding values using fieldMap 
                
             for(SVMXC__ServiceMax_Config_Data__c fld:fieldMapSetting)
             {
                 String targetFieldName = fld.SVMXC__Target_Field_Name__c;
                 String sourceFieldName = fld.SVMXC__Source_Field_Name__c;
                 Object souFldVal;

                 if(sourceFieldName != null )
                 souFldVal = souObjRec.get(sourceFieldName);

                 if(souFldVal != null)
                 {
                    WOrderHeader.put(targetFieldName, souFldVal);
                 }
             }
        } catch (Exception e){
                ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,getTAG007() ,e.getMessage()));
        }
*/ 
  		SOQLHeader = ' Select Name, SVMXC__Contact__r.Name, SVMXC__Contact__c, SVMXC__Company__c, SVMXC__Zip__c, SVMXC__Street__c, SVMXC__State__c, SVMXC__Country__c, SVMXC__City__c From SVMXC__Installed_Product__c where Id=\''+installedproductId+'\''; 
  		souObjRec = Database.query(SOQLHeader);
  		
        //Set Required:
	        if(WOrderHeader.OwnerId ==  null) WOrderHeader.OwnerId = UserInfo.getUserId();
        	if(WOrderHeader.SVMXC__Company__c == null) WOrderHeader.SVMXC__Company__c = souObjRec.SVMXC__Company__c;
        	if(WOrderHeader.SVMXC__Contact__c == null) WOrderHeader.SVMXC__Contact__c = souObjRec.SVMXC__Contact__c;
        	if(WorderHeader.SVMXC__Component__c == null) WOrderHeader.SVMXC__Component__c = souObjRec.Id;
        //Set Default Picklist Value
            if(WOrderHeader.SVMXC__Order_Status__c == null) WOrderHeader.SVMXC__Order_Status__c = 'Appt Sched';
            //if(WOrderHeader.SVMXC__Priority__c == null) WOrderHeader.SVMXC__Priority__c = utils.SVMX_getDefaultPicklistValue('SVMXC__Service_Order__c', 'SVMXC__Priority__c');
            if(WOrderHeader.SVMXC__Billing_Type__c == null) WOrderHeader.SVMXC__Billing_Type__c = utils.SVMX_getDefaultPicklistValue('SVMXC__Service_Order__c', 'SVMXC__Billing_Type__c');
    	
    	
    	//Set Address
    		if(WOrderHeader.SVMXC__Street__c == null) WOrderHeader.SVMXC__Street__c = souObjRec.SVMXC__Street__c;
    		if(WOrderHeader.SVMXC__City__c == null) WOrderHeader.SVMXC__City__c = souObjRec.SVMXC__City__c;
    		if(WOrderHeader.SVMXC__State__c == null) WOrderHeader.SVMXC__State__c = souObjRec.SVMXC__State__c;
    		if(WOrderHeader.SVMXC__Country__c == null) WOrderHeader.SVMXC__Country__c = souObjRec.SVMXC__Country__c;
    		if(WOrderHeader.SVMXC__Zip__c == null) WOrderHeader.SVMXC__Zip__c = souObjRec.SVMXC__Zip__c;
    		
    }


    //==================================== Retrieving Source Object Record =================================//
    public SVMXC__Installed_Product__c souObjRec = new SVMXC__Installed_Product__c() ;
    
    public SVMXC__Installed_Product__c getInstalledProductHeader(){
        try{
            String SOQLDetail = ' SELECT Name, SVMXC__Contact__r.Name, SVMXC__Company__c, SVMXC__Zip__c, SVMXC__Street__c, SVMXC__State__c, SVMXC__Country__c, SVMXC__City__c, OwnerId From SVMXC__Installed_Product__c where Id=\''+installedproductId+'\'';
            InstalledProductHeader= Database.query(SOQLDetail);
        } catch (Exception e){
                ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,getTAG007() ,e.getMessage()));}

        return InstalledProductHeader;            
    } 


    //============================================ New Work Order record =======================================//

    public SVMXC__Service_Order__c WOrderHeader = new SVMXC__Service_Order__c();
    
    public SVMXC__Service_Order__c getWOHeader() {
        return WOrderHeader;            
    } 
   
    //============ Method used to decide whether to show the vf page or to create wo automatically =============//
    
   /* public PageReference createwo() {
        if(rTypes.size() > 1)
            return null;
        else
            {
               PageReference pr = newTargetObj();
                return pr;
            }
    }*/

    
    //============================ Method executes on click on Create Work Order Button ========================//
    
    public PageReference newTargetObj() {
        try{
            if( SelectedRecordType != null)
            {
                 WOrderHeader.put('RecordTypeId',SelectedRecordType);
            }
                    
        insert WOrderHeader;
        } catch (Exception e){
                ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,getTAG007() ,e.getMessage()));
        	return null;
        }
/*
        if(IsHeaderOnly.toUpperCase()=='FALSE'){
        PageReference WOPage = new PageReference('/'+WOrderHeader.Id);
        WOPage.setRedirect(true);
        return WOPage;
        }
        else{
        PageReference newWOPage = new PageReference('/apex/'+SelectRecTypeWOLVFPage+'?Id='+WOrderHeader.Id);
        newWOPage.setRedirect(true);
        return newWOPage;
        }
*/
		PageReference WOPage = new PageReference('/'+WOrderHeader.Id);
        WOPage.setRedirect(true);
        return WOPage;
    }

    //======================== Method for Work Order Record Type Picklist ==========================//
     public List<SelectOption> getObjectRecordTypes(){
        
        String SOQL  = 'SELECT Id,Name  FROM RecordType where SobjectType  =\''+LineSobjectType+'\' ';        
        try{
                rTypes = Database.query(SOQL);
                for ( RecordType r : rTypes)
                {
                    rTypeNames.add(new SelectOption(r.Id,r.Name));
                }
            } catch (Exception e){ ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR,getTAG007() ,e.getMessage()));}

        return rTypeNames;
    }

     //============================== Method executes on click of Cancel Button =============================// 
     public PageReference Cancel() {
        PageReference scPage = new PageReference('/' + installedproductId);
        scPage.setRedirect(true);
        return scPage;   
     }

	public Integer getRecTypSize(){
        return rTypeNames.size();
	}
    //============================================= Translation  ===========================================// 
    // Call a Method in UTIL class to return Tags, Send SubModule ID for getting TAGS
       public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('WORD004'); 

    // Ddefine getter method for each tag you have in VF page
        public String getTAG001(){ return 'Create Work Order';} //Create WorkOrder
        public String getTAG002(){ return 'Create Work Order From Installed Product';} //Create Work Order From Case:
        public String getTAG003(){ return svmxTagList.containsKey('TAG003')?svmxTagList.get('TAG003') : '';} //Create Work Order Help
        public String getTAG004(){ return svmxTagList.containsKey('TAG004')?svmxTagList.get('TAG004') : '';} //Select Work Order Record Type
        public String getTAG005(){ return svmxTagList.containsKey('TAG005')?svmxTagList.get('TAG005') : '';} //Create Work Order (button)
        public String getTAG006(){ return svmxTagList.containsKey('TAG006')?svmxTagList.get('TAG006') : '';} //Cancel
        public String getTAG007(){ return svmxTagList.containsKey('TAG007')?svmxTagList.get('TAG007') : '';}  //Error in Create Work Order
        public String getTAG008(){ return svmxTagList.containsKey('TAG008')?svmxTagList.get('TAG008') : '';} //Source Object Case Id not found
        public String getTAG009(){ return svmxTagList.containsKey('TAG009')?svmxTagList.get('TAG009') : '';} //Settings not available for the SubModule: Create Work Order
        public String getTAG010(){ return svmxTagList.containsKey('TAG010')?svmxTagList.get('TAG010') : '';} //Settings not available for the SubModule: Create Work Order
        public String getHLPURL(){ return svmxTagList.containsKey('HLPURL')?svmxTagList.get('HLPURL') + 'WORD004' : '';}
}