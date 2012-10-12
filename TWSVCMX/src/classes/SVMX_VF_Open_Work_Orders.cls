public class SVMX_VF_Open_Work_Orders
{ 
    public SVMX_VF_Open_Work_Orders(ApexPages.StandardController controller) 
    {
      doSetup();
    }


    String cId = System.currentPageReference().getParameters().get('cid');

     String sId = System.currentPageReference().getParameters().get('id');    
     private  List<SVMXC__Service_Order__c> WorkOrder;
     private static SVMXC__Service_Order__c WOCreatedDate;
     private  List<SVMXC__Service_Order__c> WorkOrderArray = new List<SVMXC__Service_Order__c>();
     private  String HeaderfieldNames;
     private  String DetailfieldNames;
     List<SVMX_Work_OrderNLines> WOInfoArray = new List<SVMX_Work_OrderNLines>();
     
     
     SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils(); 

     SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
     public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('WORDGENREP');
     
     
    
     
     public void doSetup()
     {
        Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Order__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
        
        
        //build a list of all fieldnames for the object
        List<String> fieldList = getFieldList(fieldMap,true);      
        HeaderfieldNames = getFieldNamesFromList(fieldList);
        
         // Adding the additional fields 
        HeaderfieldNames +=' ,   SVMXC__Company__r.Name ';
        HeaderfieldNames +=' ,   SVMXC__Contact__r.Name ' ;
        HeaderfieldNames +=' ,   SVMXC__Component__r.SVMXC__Product__r.Name ';
        HeaderfieldNames +=' ,   SVMXC__Component__r.SVMXC__Serial_Lot_Number__c ';
 
        Schema.DescribeSObjectResult dsoResult2 = SVMXC__Service_Order_Line__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap2 = Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap();
    
        //build a list of all fieldnames for the object
        List<String> fieldList2 = getFieldList(fieldMap2,true);      
        DetailfieldNames = getFieldNamesFromList(fieldList2);            
    
        DetailfieldNames +=' , SVMXC__Product__r.Name,SVMXC__Product__r.ProductCode ';            
    }
          
    public  List<SVMX_Work_OrderNLines> getWorkOrders()
    {
        try
        {       
        String SOQLHeader;
       	set<String> wo_ids = new set<String>();
        Map<String, SVMXC__Service_Order__c> wo_Map = new Map<String, SVMXC__Service_Order__c>();
        Map<String, List<SVMXC__Service_Order_Line__c>> woWOL_Map = new Map<String, List<SVMXC__Service_Order_Line__c>>();
         
        SOQLHeader = '  SELECT '+HeaderfieldNames+' FROM SVMXC__Service_Order__c where SVMXC__Order_Status__c =\'Open\'';
        List<SVMXC__Service_Order_Line__c> WorkOrderDetail = new List<SVMXC__Service_Order_Line__c>();
        WorkOrder = Database.query(SOQLHeader);
          
            for(SVMXC__Service_Order__c wo:WorkOrder)
            {               
                 
                wo_ids.add(wo.Id);
            	wo_Map.put(wo.Id, wo);
               // SVMX_Work_OrderNLines WOInfoObj = new SVMX_Work_OrderNLines(); 
               // List<SVMXC__Service_Order_Line__c> lines = getWorkOrderDetail(wo);
               // WOInfoArray.add( WOInfoObj.Assign(wo,lines) );
                     
            }
            //Get Work Order Details
        String SOQLDetail;
        SOQLDetail  = '  SELECT '+DetailfieldNames+' FROM SVMXC__Service_Order_Line__c ';
        SOQLDetail += '  where SVMXC__Service_Order__c IN :wo_ids';
        WorkOrderDetail = Database.query(SOQLDetail);
        List<SVMXC__Service_Order_Line__c> woL_T;
        
        for(SVMXC__Service_Order_Line__c woL : WorkOrderDetail){
        	if(woWOL_Map.get(woL.SVMXC__Service_Order__c)!= NULL){
        		woL_T = woWOL_Map.get(woL.SVMXC__Service_Order__c);
        	}
        	else{
        		woL_T = new List<SVMXC__Service_Order_Line__c>();
        	}
        	woL_T.add(woL);
        	woWOL_Map.put(woL.SVMXC__Service_Order__c, woL_T);
        }
        
        for(SVMXC__Service_Order__c wo:WorkOrder){
        	if(woWOL_Map.get(wo.Id) != NULL){
	        	SVMX_Work_OrderNLines WOInfoObj = new SVMX_Work_OrderNLines(); 
	        	WOInfoArray.add( WOInfoObj.Assign(wo,woWOL_Map.get(wo.Id)) ); 
        	}
        }
            
        
        }catch (Exception e){}
            return WOInfoArray;            
    } 
               
    public  List<SVMXC__Service_Order_Line__c> getWorkOrderDetail(SVMXC__Service_Order__c parent)   
    {
        List<SVMXC__Service_Order_Line__c> WorkOrderDetail;
        List<SVMXC__Service_Order_Line__c> WorkOrderDetailArray = new List<SVMXC__Service_Order_Line__c> (); 
        
            try
            {
    
           
            String SOQLDetail;
    
            SOQLDetail  = '  SELECT '+DetailfieldNames+' FROM SVMXC__Service_Order_Line__c ';
            SOQLDetail += '  where SVMXC__Service_Order__c =\''+parent.Id+'\'';
            
            WorkOrderDetail = Database.query(SOQLDetail);     
                for ( SVMXC__Service_Order_Line__c WorkOrderLines : WorkOrderDetail)
                {
                    WorkOrderDetailArray.add(WorkOrderLines);
                }           
    
            } catch (Exception e){}
                return WorkOrderDetailArray;            
    }         
    
    public SVMXC__Service_Order__c getWOCreatedDate()
    {
        String scdId = System.currentPageReference().getParameters().get('SVOHeader.id');  
        
        //try
        //{
            String fieldNames;
            String SOQLforDate;
            
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Order__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();    
            
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);
            
            //SOQLforDate = '  SELECT '+fieldNames+' FROM SVMXC__Service_Order__c where SVMXC__Order_Status__c =\'Open\'';
            SOQLforDate = '  SELECT '+fieldNames+' FROM SVMXC__Service_Order__c where Id=\''+scdId+'\'';
            WOCreatedDate = Database.query(SOQLforDate);
        // } catch (Exception e){}
                return WOCreatedDate;
    }
        
    
    public String getWODate()
    {     
       // return getFormattedDate(WOCreatedDate.CreatedDate);  
        return getFormattedDate(getWOCreatedDate().CreatedDate);
    }
      
    public String getCurrentDate() 
    {
        return getFormattedDate(System.today());        
    }  
    
      //Method to convert Date into String Format     
    public String getFormattedDate(Date dat) 
    {
             String blank='';
             if (dat==null)
                return blank;
             String dtVal = String.ValueOf(dat);
             String dt;
             String mth;
             String yr;
             yr = dtVal.substring(0,4);
             mth = dtVal.substring(5,7);
             dt = dtVal.substring(8,10);
             dtVal = mth + '/'+ dt + '/'+yr;    
             return dtVal;
                  
    }     
    
     //Method to convert DateTime into String Format      
    public String getFormattedDate(DateTime dat) 
    {
             String blank='';
             if (dat==null)
                return blank;
             String dtVal = String.ValueOf(dat);
             String dt;
             String mth;
             String yr;
             yr = dtVal.substring(0,4);
             mth = dtVal.substring(5,7);
             dt = dtVal.substring(8,10);
             dtVal = mth + '/'+ dt + '/'+yr;    
             return dtVal;     
    }     
      // Method to retrieve Record Type
    /* Commented by GM 30Mar09
    public RecordType getRecordType(String Name,String SobjectType)
    {
        RecordType rType;
        String SOQL  = 'SELECT Id  FROM RecordType  where SobjectType  =\''+SobjectType+'\' AND Name=\''+Name+'\' ';        
        try
        {
            rType = Database.query(SOQL); 
        } catch (Exception e){}  
            return rType;
    }
    */
  // Methods used in generating Dynamic SOQL    
   
   public static List<String> getFieldList( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields)
   {
        List<String> fieldList = new List<String>();        
        //build dynamic list of fieldnames
        for (String fieldKey : fieldMap.keySet()) 
        {
            Schema.SObjectField fsObj = fieldMap.get(fieldKey);
            Schema.DescribeFieldResult f = fsObj.getDescribe();
            String fieldName = f.getName();            
                if (selectAllFields) 
                {
                    fieldList.add(fieldName);
                    System.debug('Adding '+fieldName);
                } 
                else 
                {
                    if (f.getName()=='Id' || f.isNameField() || f.isCustom()) 
                    {
                        fieldList.add(fieldName);
                        System.debug('Adding :else: '+fieldName);
                    }
                }
        }        
        return fieldList;
   }
   
   public static String getFieldNamesFromList(List<String> fieldList) 
   {
        String fieldNames = '';
        for (String field : fieldList) 
        {
            if (fieldNames.length()>0) 
            {
                fieldNames += ',';
            }
            fieldNames += field;
        }        
        return fieldNames;
    }  
     
   // Getter Setter for Generating the report dynemic as PDF , XLS , DOC
    Public String getcontype()
    { 
       String a;
       if(cId == 'xls')
       {
         a = 'application/vnd.ms-excel#Report.xls';
       }
       else If(cId == 'doc')
       {
         a = 'application/msword#Report.doc';
       }
       return a; 
    }  
     Public String getrender()
     { 
      String b;
      if (cId == 'pdf')
      { 
         b = 'pdf';
      }
       return b;   
     }
     
     /// Getter Setter For Tags 
      public String getREPTAG001(){ return svmxTagList.containsKey('REPTAG001')?svmxTagList.get('REPTAG001') : '';}
      public String getREPTAG002(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG002') : '';}

  
   
       
}