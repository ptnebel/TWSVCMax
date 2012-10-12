public class SVMX_VF_ServiceQuote
{
    public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
    public list<SVMXC__Quote__c> SVQuote= new list<SVMXC__Quote__c>();
    List<Wraper> wrpQuote = new List<Wraper>();
    public string strDispTyp = System.currentPageReference().getParameters().get('DispTyp');
        public string getstrDispTyp(){if(this.strDispTyp == 'pdf') return this.strDispTyp; else return null;}
    public string contype = System.currentPageReference().getParameters().get('DispTyp');
        public string getcontype (){return COMM_Utils_Reports.getcontype(strDispTyp);}
    
    String strRecordId = System.currentPageReference().getParameters().get('RecordId');
    public SVMX_VF_ServiceQuote(ApexPages.StandardController controller) 
    {
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Quote__c.fields.getMap();
        String fieldNames = getFieldNamesFromList(getFieldList(fieldMap,true));
                fieldNames +=' ,SVMXC__Service_Order__r.Name';
                fieldNames +=' ,SVMXC__Company__r.Name';
                fieldNames +=' ,SVMXC__Contact__r.Name'; 
                fieldNames +=' ,SVMXC__Company__r.BillingStreet';
                fieldNames +=' ,SVMXC__Company__r.BillingCity';
                fieldNames +=' ,SVMXC__Company__r.BillingState';
                fieldNames +=' ,SVMXC__Company__r.BillingPostalCode';
                fieldNames +=' ,SVMXC__Company__r.BillingCountry';

        string d = System.currentPageReference().getParameters().get('d');
        if(d<> null && d.length() > 0 )
        {
            mlst = [select SVMXC__Object_Id__c from SVMXC__ServiceMax_List__c where SVMXC__Source_Location__c = :d ];
            list<string> s= new list<string>();
            string strIds = '(';
            for(SVMXC__ServiceMax_List__c o :mlst )
            {
                s.add(o.ID);
                if (mlst[0].Id != o.ID)
                    strIds += ', ';
                strIds += '\''+o.SVMXC__Object_Id__c +'\'';
            }
            strIds +=')';
             string q = 'select '+ fieldNames +'  from SVMXC__Quote__c s where s.id in ' + strIds;
            if (mlst.size()>0)
                SVQuote = database.query(q);
        } 
        else
        {
            if(strRecordId <> null && strRecordId.length() > 0 )
            {
                string q = 'select '+ fieldNames +'  from SVMXC__Quote__c s where s.id = \'' + strRecordId + '\'';
                SVQuote = database.query(q);
            }
        } 

    }


   SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils(); 
   SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
   public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('WORDREP001');   
   String cId = System.currentPageReference().getParameters().get('cid');
   String sId = System.currentPageReference().getParameters().get('id'); 
       //SVMXC__Quote__c
       public  list<Wraper> getSVQuote()
       {
           list<string> setID = new list<string>();
           for(SVMXC__Quote__c wo:SVQuote)
           {
             setId.add(wo.id);
           }
           List<SVMXC__Quote_Line__c> lines = getPartsOrderDetails(setId);
           for(SVMXC__Quote__c wo:SVQuote)
           {              
                List<SVMXC__Quote_Line__c> lines2 = new List<SVMXC__Quote_Line__c>(); 
                for(SVMXC__Quote_Line__c o :lines )
                { 
                    if(wo.id == o.SVMXC__Quote__c )
                        lines2.add(o);
                }
                Wraper WOInfoObj = new Wraper(wo, lines2);
                WOInfoObj.SVQDate = getFormattedDate(wo.CreatedDate);
                WOInfoObj.ValUnll = getFormattedDate(wo.SVMXC__Valid_Until__c);
                wrpQuote.add(WOInfoObj);
           }
            return wrpQuote;    
       }
         
       public  List<SVMXC__Quote_Line__c> getPartsOrderDetails(list<string> setID)   
        {
        List<SVMXC__Quote_Line__c> PartsOrderDetails;
        List<SVMXC__Quote_Line__c> PartsOrderDetailsArray = new List<SVMXC__Quote_Line__c> ();
        
            /*try
            {
                String fieldNames;
                String SOQLDetail;
                
                Schema.DescribeSObjectResult dsoResult = SVMXC__Quote_Line__c.sObjectType.getDescribe();
                Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Quote_Line__c.fields.getMap();
                
                List<String> fieldList = getFieldList(fieldMap,true);      
                fieldNames = getFieldNamesFromList(fieldList);            
                
                SOQLDetail  = '  SELECT '+fieldNames+' FROM SVMXC__Quote_Line__c ';
                SOQLDetail += '  where SVMXC__Quote__c =\''+sId+'\'';
                
                PartsOrderDetails = Database.query(SOQLDetail);     
                for ( SVMXC__Quote_Line__c PartsOrderLines : PartsOrderDetails)
                    {
                          PartsOrderDetailsArray.add(PartsOrderLines);
                    }           
        
            } catch (Exception e){}
                return PartsOrderDetailsArray;*/
            String fieldNames;
            Schema.DescribeSObjectResult dsoResult = SVMXC__Quote_Line__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Quote_Line__c.fields.getMap();
                
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);  
            fieldNames +=' , SVMXC__Product__r.Name, SVMXC__Product__r.ProductCode ';                
            string strIds = '(';
            for(string s :setID)
            {
                if (setID[0] != s)
                    strIds += ', ';
                strIds += '\''+s+'\'';
            }
            strIds +=')';
             string q = 'select '+ fieldNames +'  from SVMXC__Quote_Line__c s where s.SVMXC__Quote__c in ' + strIds;

                PartsOrderDetails = database.query(q);
                /*for ( SVMXC__Quote_Line__c ShipmentLines : PartsOrderDetails)
                {
                    PartsOrderDetailsArray.add(ShipmentLines);
                } */          
                           system.debug('asdf'+q);
                return PartsOrderDetails;             
        }                 
             

        
          
      
       
             // Method to retrieve Record Type
       /* Commented By GM 30Mar09
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
                } 
            else {
                if (f.getName()=='Id' || f.isNameField() || f.isCustom()) {
                    fieldList.add(fieldName);
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
//Getter Setter for Tags
    public String getREPTAG001(){ return svmxTagList.containsKey('REPTAG001')?svmxTagList.get('REPTAG001') : '';}
    public String getREPTAG002(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG002') : '';}
    public String getREPTAG003(){ return svmxTagList.containsKey('REPTAG003')?svmxTagList.get('REPTAG003') : '';}
    public String getREPTAG004(){ return svmxTagList.containsKey('REPTAG004')?svmxTagList.get('REPTAG004') : '';}
    public String getREPTAG005(){ return svmxTagList.containsKey('REPTAG005')?svmxTagList.get('REPTAG005') : '';}
    /*
    public String getTAG001() {return svmxTagList.containsKey('TAG001')?svmxTagList.get('TAG001') : 'Quote Number';}//Quote Number
    public String getTAG002() {return svmxTagList.containsKey('TAG002')?svmxTagList.get('TAG002') : 'Created Date';}//Created Date
    public String getTAG003() {return svmxTagList.containsKey('TAG003')?svmxTagList.get('TAG003') : 'Account';}//Account
    public String getTAG004() {return svmxTagList.containsKey('TAG004')?svmxTagList.get('TAG004') : 'Contact';}//Contact
    
    public String getTAG005() {return svmxTagList.containsKey('TAG005')?svmxTagList.get('TAG005') : 'Quote Amount';}//Quote Amount
    public String getTAG006() {return svmxTagList.containsKey('TAG006')?svmxTagList.get('TAG006') : 'Valid Until';}//Valid Until
    public String getTAG007() {return svmxTagList.containsKey('TAG007')?svmxTagList.get('TAG007') : 'Line Type';}//Line Type
    public String getTAG008() {return svmxTagList.containsKey('TAG008')?svmxTagList.get('TAG008') : 'Line Description';}//Line Description
    public String getTAG009() {return svmxTagList.containsKey('TAG009')?svmxTagList.get('TAG009') : 'Product';}//Product
    public String getTAG010() {return svmxTagList.containsKey('TAG010')?svmxTagList.get('TAG010') : 'Unit Price';}//Unit Price
    public String getTAG011() {return svmxTagList.containsKey('TAG011')?svmxTagList.get('TAG011') : 'Qty';}//Qty
    public String getTAG012() {return svmxTagList.containsKey('TAG012')?svmxTagList.get('TAG012') : 'Discount';}//Discount
    public String getTAG013() {return svmxTagList.containsKey('TAG013')?svmxTagList.get('TAG013') : 'Line Price';}//Line Price
    */

public class Wraper 
{
    public string SVQDate;
    public string getSVQDate() {return this.SVQDate;}
    public string ValUnll;
    public string getValUnll() {return this.ValUnll;}
    public SVMXC__Quote__c sObj;
    public SVMXC__Quote__c getsObj(){return this.sObj;}
    public list<SVMXC__Quote_Line__c> lstsObj;
    public list<SVMXC__Quote_Line__c> getlstsObj(){return this.lstsObj;}
    public Wraper(SVMXC__Quote__c b , list<SVMXC__Quote_Line__c> lstb)
    {
        sObj = b;
        lstsObj=lstb;
    }
   
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
}