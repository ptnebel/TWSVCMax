public class SVMX_VF_ServiceQuoteFromEstimates
{
    public SVMX_VF_ServiceQuoteFromEstimates(ApexPages.StandardController controller) {

    }


        String cId = System.currentPageReference().getParameters().get('cid');

        String sId = System.currentPageReference().getParameters().get('id');    
    private static SVMXC__Service_Order__c SVQFMEstimate;
    
     SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils(); 
 
     SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
     public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('WORDGENREP');

    
    
    public  SVMXC__Service_Order__c getSVQFMEstimate()
    {
        try
        {
            String fieldNames;
            String SOQLHeader;
            
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Order__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
            
                //build a list of all fieldnames for the object
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);
            
            fieldNames +=' ,   SVMXC__Component__r.Name, SVMXC__Company__r.Name, SVMXC__Contact__r.Name ';              
            fieldNames +=' ,    SVMXC__Component__r.SVMXC__Serial_Lot_Number__c';
            
            SOQLHeader = '  SELECT '+fieldNames+' FROM SVMXC__Service_Order__c where Id=\''+sId+'\''; 
            SVQFMEstimate = Database.query(SOQLHeader);
                        
        }catch (Exception e){}
            return SVQFMEstimate;
    }
    
    public  List<SVMXC__Service_Order_Line__c> getSVQuoteDetails()
    {
        List<SVMXC__Service_Order_Line__c> SVQuoteDetails;
        List<SVMXC__Service_Order_Line__c> SVQuoteDetailsArray = new List<SVMXC__Service_Order_Line__c> ();
            try
            {
                String fieldNames;
                String SOQLDetail;
                
                Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Order_Line__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap();
                
                List<String> fieldList = getFieldList(fieldMap,true);      
                fieldNames = getFieldNamesFromList(fieldList);            
                
                fieldNames +=' , SVMXC__Product__r.Name';
                
                SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Service_Order_Line__c ';
                SOQLDetail += '  where SVMXC__Service_Order__c =\''+sId+'\'';
                
                SVQuoteDetails = Database.query(SOQLDetail);   
                for ( SVMXC__Service_Order_Line__c SVQLines : SVQuoteDetails)
                    {
                          SVQuoteDetailsArray.add(SVQLines);
                    }           
            }catch (Exception e){}
               return SVQuoteDetailsArray;
    }
    
    public String getSVQEDate() 
    {
       return getFormattedDate(SVQFMEstimate.CreatedDate);   
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
        try{
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
            else {
                if (f.getName()=='Id' || f.isNameField() || f.isCustom()) {
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
        for (String field : fieldList) {
            if (fieldNames.length()>0) {
                fieldNames += ',';
            }
            fieldNames += field;
    }        
        return fieldNames;
   }    
   
   
   ///Getter Setter for Generating the report dynemic as PDF , XLS , DOC

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
      public String getREPTAG003(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG003') : '';}
      public String getREPTAG004(){ return svmxTagList.containsKey('REPTAG004')?svmxTagList.get('REPTAG004') : '';}


                        
}