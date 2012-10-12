public class SVMX_VF_ServiceContract 
{
 
 

// Declration of Globle Variables.....

    String cId = System.currentPageReference().getParameters().get('cid');
    String sId = System.currentPageReference().getParameters().get('id');
    private static SVMXC__Service_Contract__c SVContract;
    
    
    // Getting the service Controct information....
    public  SVMXC__Service_Contract__c getSVContract()
    {
        try
        {
            String fieldNames;
            String SOQLHeader;
            
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract__c.fields.getMap();
            
                //build a list of all fieldnames for the object
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);
            
                 // Adding the additional fields
            
            fieldNames +=' ,   SVMXC__Company__r.Name ';
            fieldNames +=' ,   SVMXC__Contact__r.Name';
        
            
            SOQLHeader = '  SELECT '+fieldNames+' FROM SVMXC__Service_Contract__c where Id=\''+sId+'\''; 
            SVContract = Database.query(SOQLHeader);
        }catch (Exception e){}
            return SVContract;      
    }
    
// getting the Covered Products (Installed Product) information

    public  List<SVMXC__Service_Contract_Products__c> getSVCProductDetails()
    {
        List<SVMXC__Service_Contract_Products__c> SVCProductDetails;
        List<SVMXC__Service_Contract_Products__c> SVCProductDetailsArray = new List<SVMXC__Service_Contract_Products__c> ();
        
            try
            {
                String fieldNames;
                String SOQLDetail;
                
                Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Products__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Products__c.fields.getMap();
                
                List<String> fieldList = getFieldList(fieldMap,true);      
                fieldNames = getFieldNamesFromList(fieldList);            
                
                fieldNames +=' , SVMXC__Installed_Product__r.Name';
                fieldNames +=' , SVMXC__Product__r.Name';
                
                
                SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Service_Contract_Products__c ';
                SOQLDetail += '  where SVMXC__Service_Contract__c =\''+sId+'\'';
                
                SVCProductDetails = Database.query(SOQLDetail);     
                for ( SVMXC__Service_Contract_Products__c SVCProductLines : SVCProductDetails)
                    {
                        SVCProductDetailsArray.add(SVCProductLines);
                    }           
        
           } catch (Exception e){}
                return SVCProductDetailsArray;            
        }
        
// getting the Included Services information...       
        
        public List<SVMXC__Service_Contract_Services__c> getSVCIncludedServices() 
    {
    
        List<SVMXC__Service_Contract_Services__c> SVCServiceDetails;
        List<SVMXC__Service_Contract_Services__c> SVCServiceDetailsArray = new List<SVMXC__Service_Contract_Services__c> ();
        
            try
            {
                String fieldNames;
                String SOQLDetail;
                
                Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Services__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Services__c.fields.getMap();
                
                List<String> fieldList = getFieldList(fieldMap,true);      
                fieldNames = getFieldNamesFromList(fieldList);            
                
                fieldNames +=' , SVMXC__Service__r.Name';
               // fieldNames +=' , SVMXC__Product__r.Name';
                
                
                SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Service_Contract_Services__c ';
                SOQLDetail += '  where SVMXC__Service_Contract__c =\''+sId+'\'';
                
                SVCServiceDetails = Database.query(SOQLDetail);     
                for ( SVMXC__Service_Contract_Services__c SVCServiceLines : SVCServiceDetails)
                    {
                        SVCServiceDetailsArray.add(SVCServiceLines);
                    }           
        
           } 
           catch (Exception e){}
           return SVCServiceDetailsArray;
        
    }
    
    // getting the Covered Location information...       
        
        public List<SVMXC__Service_Contract_Sites__c> getSVCCoverdLocation() 
    {
    
        List<SVMXC__Service_Contract_Sites__c> SVCLocationDetails;
        List<SVMXC__Service_Contract_Sites__c> SVCLocationDetailsArray = new List<SVMXC__Service_Contract_Sites__c> ();
        
            try
            {
                String fieldNames;
                String SOQLDetail;
                
                Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Sites__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Sites__c.fields.getMap();
                
                List<String> fieldList = getFieldList(fieldMap,true);      
                fieldNames = getFieldNamesFromList(fieldList);            
                
                fieldNames +=' , SVMXC__Site__r.Name';
               // fieldNames +=' , SVMXC__Product__r.Name';
                
                
                SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Service_Contract_Sites__c ';
                SOQLDetail += '  where SVMXC__Service_Contract__c =\''+sId+'\'';
                
                SVCLocationDetails = Database.query(SOQLDetail);     
                for ( SVMXC__Service_Contract_Sites__c SVCLocationLines : SVCLocationDetails)
                    {
                        SVCLocationDetailsArray.add(SVCLocationLines);
                    }           
        
           } 
           catch (Exception e){}
           system.debug('amarlocation'+SVCLocationDetailsArray);
           return SVCLocationDetailsArray;
        
    }
    
     // getting the Entitled Contact information...       
        
        public List<SVMXC__Service_Contract_Contacts__c> getSVCEntitledContacts()
    {
    
        List<SVMXC__Service_Contract_Contacts__c> SVCContactDetails;
        List<SVMXC__Service_Contract_Contacts__c> SVCContactDetailsArray = new List<SVMXC__Service_Contract_Contacts__c> ();
        
            try
            {
                String fieldNames;
                String SOQLDetail;
                
                Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Contacts__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Contacts__c.fields.getMap();
                
                List<String> fieldList = getFieldList(fieldMap,true);      
                fieldNames = getFieldNamesFromList(fieldList);            
                
                fieldNames +=' , SVMXC__Contact__r.Name';
               // fieldNames +=' , SVMXC__Product__r.Name';
                
                
                SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Service_Contract_Contacts__c ';
                SOQLDetail += '  where SVMXC__Service_Contract__c =\''+sId+'\'';
                
                SVCContactDetails = Database.query(SOQLDetail);     
                for ( SVMXC__Service_Contract_Contacts__c SVCContactLines : SVCContactDetails)
                    {
                        SVCContactDetailsArray.add(SVCContactLines);
                    }           
        
           } 
           catch (Exception e){}
           system.debug('amarlocation'+SVCContactDetailsArray);
           return SVCContactDetailsArray;
        
    }
    
        
        // Methods for dynemic generation of PDF,XLS,Doc Report
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
        
       // Method for date            
    public string getSVCDate() 
    {
        return getFormattedDate(SVContract.CreatedDate);   
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
    
    public Integer getRenNum()
    {
        if(SVContract.SVMXC__Renewal_Number__c!=Null)
        {
            double RenewalNo;
            RenewalNo = SVContract.SVMXC__Renewal_Number__c;
            Integer RenNum = RenewalNo.intValue();
            return RenNum;
        }
        else
            return null;
    }        
    
    public String getStartDt() 
    {
        String StartDt = getFormattedDate(SVContract.SVMXC__Start_Date__c); 
            return StartDt;        
    } 
    
    public String getEndDt() 
    {
        String EndDt = getFormattedDate(SVContract.SVMXC__End_Date__c); 
            return EndDt;        
    }
    public String getRenewDt() 
    {
        String RenewDt = getFormattedDate(SVContract.SVMXC__Renewal_Date__c); 
            return RenewDt;        
    }
    
}