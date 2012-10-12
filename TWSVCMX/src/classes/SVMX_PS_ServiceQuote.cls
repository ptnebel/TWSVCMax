public class SVMX_PS_ServiceQuote 
{
    String cId = System.currentPageReference().getParameters().get('cid');

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

        String sId = System.currentPageReference().getParameters().get('id');    
        private static SVMXC__Quote__c SVQuote;
        
        public  SVMXC__Quote__c getSVQuote()
        {
            try
            {
                String fieldNames;
                String SOQLHeader;
                 
                Schema.DescribeSObjectResult dsoResult = SVMXC__Quote__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Quote__c.fields.getMap();
                
                    //build a list of all fieldnames for the object
                List<String> fieldList = getFieldList(fieldMap,true);      
                fieldNames = getFieldNamesFromList(fieldList);
                

                fieldNames +=' ,SVMXC__Service_Order__r.Name';
                fieldNames +=' ,SVMXC__Service_Order__r.SVMXC__Case__r.CaseNumber';
                fieldNames +=' ,SVMXC__Company__r.Name';
                fieldNames +=' ,SVMXC__Contact__r.Name';
                fieldNames +=' ,SVMXC__Company__r.Phone'; 
                fieldNames +=' ,SVMXC__Company__r.BillingStreet';
                fieldNames +=' ,SVMXC__Company__r.BillingCity';
                fieldNames +=' ,SVMXC__Company__r.BillingState';
                fieldNames +=' ,SVMXC__Company__r.BillingPostalCode';
                fieldNames +=' ,SVMXC__Company__r.BillingCountry';
                fieldNames +=' ,SVMXC__Company__r.AccountNumber';
                fieldNames +=' ,CreatedBy.FirstName, CreatedBy.LastName ';
                    
                
                SOQLHeader = '  SELECT '+fieldNames+' FROM SVMXC__Quote__c where Id=\''+sId+'\''; 
                SVQuote = Database.query(SOQLHeader);
            } catch (Exception e){}
                    return SVQuote;            
        }
        
        public  List<SVMXC__Quote_Line__c> getSVQuoteDetails()  
        {
            List<SVMXC__Quote_Line__c> SVQuoteDetails;
            List<SVMXC__Quote_Line__c> SVQuoteDetailsArray = new List<SVMXC__Quote_Line__c> ();
            try
            {
                String fieldNames;
                String SOQLDetail;
                
                Schema.DescribeSObjectResult dsoResult = SVMXC__Quote_Line__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Quote_Line__c.fields.getMap();
                
                List<String> fieldList = getFieldList(fieldMap, true);
                fieldNames = getFieldNamesfromList(fieldList);
                
                
                fieldNames +=',SVMXC__Product__r.Name';
                fieldNames +=',SVMXC__Product__r.SVMXC__Unit_Of_Measure__c';
                                
                SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Quote_Line__c ';
                SOQLDetail += '  where SVMXC__Quote__c =\''+sId+'\'';
                
                SVQuoteDetails = Database.query(SOQLDetail);     
                for ( SVMXC__Quote_Line__c SVQuoteLines : SVQuoteDetails)
                    {
                          SVQuoteDetailsArray.add(SVQuoteLines);
                    }                   
              } catch (Exception e){}
                    return SVQuoteDetailsArray;             
        }
           
           ///
        public string getSVQDate() 
        {
           return getFormattedDate(SVQuote.CreatedDate);  
        }
        
        ///
        public string getValUnll() 
        {
            //String ValUnl = SVQuote.SVMXC__Valid_Until__c;
           String ValUnll = getFormattedDate(SVQuote.SVMXC__Valid_Until__c);//SVQuote.SVMXC__Valid_Until__c);  
            return ValUnll;
        }
      
            ///   
        public String getCurrentDate() 
        {
            return getFormattedDate(System.today());        
        }    
        
        public String getQuoteCreatedDate()
        {     
            return getFormattedDate(SVQuote.CreatedDate);  
        }  
                  
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
     static testMethod void SVMX_PS_ServiceQuote_Test()
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
        //Create Product
        Product2 pr = new Product2 (
                                            Name ='Prod',
                                            ProductCode='Prod',
                                            //CurrencyIsoCode = 'USD', 
                                            SVMXC__Inherit_Parent_Warranty__c =True 
                                            ); 
        insert pr;   
        
        //Create Work Order
        SVMXC__Service_Order__c svo = new SVMXC__Service_Order__c (
                                        SVMXC__Case__c = cs.Id ,
                                        SVMXC__Company__c = ac.Id , 
                                        SVMXC__Order_Status__c = 'Open',
                                        SVMXC__Priority__c ='Medium',
                                        SVMXC__Order_Type__c='Field Service'
                                        );
         insert svo;
         
         //Create QUOTE
         SVMXC__Quote__c qt = new SVMXC__Quote__c (
                                        SVMXC__Contact__c = ct.Id,
                                        SVMXC__Company__c = ac.Id , 
                                        SVMXC__Service_Order__c = svo.Id,
                                        SVMXC__Status__c = 'Draft',
                                        SVMXC__Valid_Until__c = system.Today(),
                                        SVMXC__Quote_Amount2__c=200
                                        );
         insert qt;
         //Create Quote Line
         SVMXC__Quote_Line__c qtLine = new SVMXC__Quote_Line__c (
                                        SVMXC__Quote__c = qt.Id,
                                        SVMXC__Quantity2__c = 2 , 
                                        SVMXC__Unit_Price2__c = 2,
                                        SVMXC__Product__c = pr.Id
                                        );
         insert qtLine;
         
        //Test converage for the SVMX_VF_ServiceReport visualforce page
        PageReference pageRef = Page.SVMX_VF_ServiceQuote;
        pageRef.getParameters().put('id',qt.Id);
        Test.setCurrentPageReference(pageRef);
        
        // create an instance of the controller
        SVMX_PS_ServiceQuote myPageCon = new SVMX_PS_ServiceQuote();
        
        //try calling methods/properties of the controller in all possible scenarios
        // to get the best coverage.
        SVMXC__Quote__c p = myPageCon.getSVQuote();
    
        List<SVMXC__Quote_Line__c> pLines =  myPageCon.getSVQuoteDetails();
     
        String strQtdt =  myPageCon.getSVQDate();
        String strValid =  myPageCon.getValUnll();
        String strCurrDt =  myPageCon.getCurrentDate();
        
        Date dat = System.today();
        String strDt =  myPageCon.getFormattedDate(dat);
        String str1 =  myPageCon.getcontype();
        String str2 =  myPageCon.getrender();  
    }         
}