public class SVMX_PS_ServiceReportEST {
	String cId = System.currentPageReference().getParameters().get('DispTyp');
   
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


    String CreateDate;
            
     String sId = System.currentPageReference().getParameters().get('RecordId');    
     private static SVMXC__Service_Order__c WorkOrder;
      
     public  SVMXC__Service_Order__c getWorkOrder()
     {
     try{
        String fieldNames;
        String SOQLHeader;

        Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Order__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
        
        
        //build a list of all fieldnames for the object
        List<String> fieldList = getFieldList(fieldMap,true);      
        fieldNames = getFieldNamesFromList(fieldList);
        
         // Adding the additional fields
         fieldNames +=' ,   SVMXC__Company__r.Name ';
         fieldNames +=' ,   SVMXC__Company__r.BillingStreet,SVMXC__Company__r.BillingCity,SVMXC__Company__r.BillingState,SVMXC__Company__r.BillingCountry,SVMXC__Company__r.BillingPostalCode,SVMXC__Company__r.AccountNumber ';
         fieldNames +=' ,   SVMXC__Contact__r.Name ' ;
         fieldNames +=' ,   SVMXC__Component__r.SVMXC__Product__r.Name ';
         fieldNames +=' ,   SVMXC__Component__r.SVMXC__Serial_Lot_Number__c ';
         fieldNames +=' ,   SVMXC__Contact__r.Phone';
         fieldNames +=' ,   SVMXC__Group_Member__r.Name';
        
        SOQLHeader = '  SELECT '+fieldNames+' FROM SVMXC__Service_Order__c where Id=\''+sId+'\''; 
        WorkOrder = Database.query(SOQLHeader);
        } catch (Exception e){}
            return WorkOrder;            
    } 
    
    public  List<SVMXC__Service_Order_Line__c> getWorkOrderDetail()   
    {
        List<SVMXC__Service_Order_Line__c> WorkOrderDetail;
        List<SVMXC__Service_Order_Line__c> WorkOrderDetailArray = new List<SVMXC__Service_Order_Line__c> (); 
        RecordType rtSvoLine = [SELECT Id FROM RecordType WHERE SobjectType = 'SVMXC__Service_Order_Line__c' AND Name = 'Estimate' Limit 1];
    
        try{
    
            String fieldNames;
            String SOQLDetail;
    
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Order_Line__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap();
    
            //build a list of all fieldnames for the object
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);            
    
            fieldNames +=' , SVMXC__Product__r.Name,SVMXC__Product__r.ProductCode ';            
    
            SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Service_Order_Line__c ';
            SOQLDetail += '  where SVMXC__Service_Order__c =\''+sId+'\' and RecordTypeId=\''+rtSvoLine.id+'\'';        
    
            WorkOrderDetail = Database.query(SOQLDetail);     
            for ( SVMXC__Service_Order_Line__c WorkOrderLines : WorkOrderDetail)
                {
                      WorkOrderDetailArray.add(WorkOrderLines);
                }           
    
            } catch (Exception e){}
            return WorkOrderDetailArray;            
    }         
        
        
      public String getWODate()
      {     
      	if(WorkOrder!=null){
        	return getFormattedDate(WorkOrder.CreatedDate);  
      	} else return getFormattedDate(System.today());
      }
      
       public String getCurrentDate() {
        return getFormattedDate(System.today());        
    }  
    
    public String getCreateDate() 
    {
        if(WorkOrder.CreatedDate != null)
        {
            return getFormattedDate(WorkOrder.CreatedDate);        
        }
        else
        {
            return null;
        }
    }
    
    public String getCloseDate() 
    {
        if(WorkOrder.SVMXC__Closed_On__c != null)
        {
            return getFormattedDate(WorkOrder.SVMXC__Closed_On__c);        
        }
        else
        {
            return null;
        }
    } 
    
           
      //Method to convert Date into String Format     
    public String getFormattedDate(Date dat) {
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
    public String getFormattedDate(DateTime dat) {
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
   
   public static String getFieldNamesFromList(List<String> fieldList) {
        String fieldNames = '';
        for (String field : fieldList) {
            if (fieldNames.length()>0) {
                fieldNames += ',';
            }
            fieldNames += field;
        }        
        return fieldNames;
    }  
     
 static testMethod void SVMX_PS_ServiceReportEST_Test()
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
         

        
        
        //Test converage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.SVMX_PS_ServiceReportEST;
        pageRef.getParameters().put('id',svo.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_PS_ServiceReportEST myPageCon = new SVMX_PS_ServiceReportEST();
        
        //try calling methods/properties of the controller in all possible scenarios
        // to get the best coverage.
        SVMXC__Service_Order__c pWO = myPageCon.getWorkOrder();
    
        List<SVMXC__Service_Order_Line__c> pWOLines =  myPageCon.getWorkOrderDetail();
     
        String strWOdt =  myPageCon.getWODate();
        String strCurrDt =  myPageCon.getCurrentDate();
        
        Date dat = System.today();
        String strDt =  myPageCon.getFormattedDate(dat);
        String str1 =  myPageCon.getcontype();
        String str2 =  myPageCon.getrender();  
            
    } 
	
}