public class SVMX_VF_Service_Contract
{ 
    public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
    public list<SVMXC__Service_Contract__c> lstSerContract= new list<SVMXC__Service_Contract__c>();
    List<Wraper> RMAShipment = new List<Wraper>();
    public string strDispTyp = System.currentPageReference().getParameters().get('DispTyp');
        public string getstrDispTyp(){if(this.strDispTyp == 'pdf') return this.strDispTyp; else return null;}
    public string contype = System.currentPageReference().getParameters().get('DispTyp');
        public string getcontype (){return COMM_Utils_Reports.getcontype(strDispTyp);}
    
    String strRecordId = System.currentPageReference().getParameters().get('RecordId');
    public SVMX_VF_Service_Contract(ApexPages.StandardController controller) 
    {
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract__c.fields.getMap();
        String fieldNames = getFieldNamesFromList(getFieldList(fieldMap,true));
        fieldNames +=' ,   SVMXC__Company__r.Name ';
        fieldNames +=' ,   SVMXC__Contact__r.Name';

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
             string q = 'select '+ fieldNames +'  from SVMXC__Service_Contract__c s where s.id in ' + strIds;
            if (mlst.size()>0)
                lstSerContract = database.query(q);
        } 
        else
        {
            if(strRecordId <> null && strRecordId.length() > 0 )
            {
                string q = 'select '+ fieldNames +'  from SVMXC__Service_Contract__c s where s.id = \'' + strRecordId + '\'';
                lstSerContract = database.query(q);
            }
        } 

    }


   SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils(); 
   SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
   public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('PORDGENREP');   
   
    

    String cId = System.currentPageReference().getParameters().get('cid');

    String sId = System.currentPageReference().getParameters().get('id');    
       private static SVMXC__Service_Contract__c RMAShipment;
       //SVMXC__Service_Contract__c
       public  list<Wraper> getSVContract()
       {
    
           list<string> setID = new list<string>();
           for(SVMXC__Service_Contract__c wo:lstSerContract)
           {
             setId.add(wo.id);
           }
           List<SVMXC__Service_Contract_Products__c> lstPD = getSVCProductDetails(setId);
           List<SVMXC__Service_Contract_Services__c> lstIS = getSVCIncludedServices(setId);
           List<SVMXC__Service_Contract_Sites__c> lstCL = getSVCCoverdLocation(setId);
           List<SVMXC__Service_Contract_Contacts__c> lstEC = getSVCEntitledContacts(setId);
           
           for(SVMXC__Service_Contract__c wo:lstSerContract)
           {              
                List<SVMXC__Service_Contract_Products__c> lstPD2 = new List<SVMXC__Service_Contract_Products__c>();
                List<SVMXC__Service_Contract_Services__c> lstIS2 = new List<SVMXC__Service_Contract_Services__c>();
                List<SVMXC__Service_Contract_Sites__c> lstCL2 = new List<SVMXC__Service_Contract_Sites__c>();
                List<SVMXC__Service_Contract_Contacts__c> lstEC2 = new List<SVMXC__Service_Contract_Contacts__c>(); 
                
                for(SVMXC__Service_Contract_Products__c o :lstPD )
                { 
                    if(wo.id == o.SVMXC__Service_Contract__c )
                        lstPD2.add(o);
                }
                for(SVMXC__Service_Contract_Services__c o :lstIS )
                { 
                    if(wo.id == o.SVMXC__Service_Contract__c )
                        lstIS2.add(o);
                }
                for(SVMXC__Service_Contract_Sites__c o :lstCL )
                { 
                    if(wo.id == o.SVMXC__Service_Contract__c )
                        lstCL2.add(o);
                }
                for(SVMXC__Service_Contract_Contacts__c o :lstEC )
                { 
                    if(wo.id == o.SVMXC__Service_Contract__c )
                        lstEC2.add(o);
                }
                Wraper WOInfoObj = new Wraper(wo, lstPD2, lstIS2, lstCL2,lstEC2);
                WOInfoObj.StartDt = getFormattedDate(wo.SVMXC__Start_Date__c); 
                WOInfoObj.EndDt = getFormattedDate(wo.SVMXC__End_Date__c); 
                WOInfoObj.RenewDt = getFormattedDate(wo.SVMXC__Renewal_Date__c); 
                WOInfoObj.RenNum = wo.SVMXC__Renewal_Number__c!=Null ? wo.SVMXC__Renewal_Number__c.intValue() : null; 
                RMAShipment.add( WOInfoObj );
           }
                   
            return RMAShipment;    
       }
         
       public  List<SVMXC__Service_Contract_Products__c> getSVCProductDetails(list<string> setID)   
       {
            List<SVMXC__Service_Contract_Products__c> PartsOrderDetails;
            List<SVMXC__Service_Contract_Products__c> PartsOrderDetailsArray = new List<SVMXC__Service_Contract_Products__c> ();
            String fieldNames;
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Products__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Products__c.fields.getMap();
                
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);  
            fieldNames +=' , SVMXC__Installed_Product__r.Name';
            fieldNames +=' , SVMXC__Product__r.Name';            
            string strIds = '(';
            for(string s :setID)
            {
                if (setID[0] != s)
                    strIds += ', ';
                strIds += '\''+s+'\'';
            }
            strIds +=')';
            string q = 'select '+ fieldNames +'  from SVMXC__Service_Contract_Products__c s where s.SVMXC__Service_Contract__c in ' + strIds;
            PartsOrderDetails = database.query(q);
            return PartsOrderDetails;             
        }          
        public  List<SVMXC__Service_Contract_Services__c> getSVCIncludedServices(list<string> setID)   
        {
            List<SVMXC__Service_Contract_Services__c> PartsOrderDetails;
            List<SVMXC__Service_Contract_Services__c> PartsOrderDetailsArray = new List<SVMXC__Service_Contract_Services__c> ();
            String fieldNames;
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Services__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Services__c.fields.getMap();
                
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);  
            fieldNames +=' , SVMXC__Service__r.Name';
            string strIds = '(';
            for(string s :setID)
            {
                if (setID[0] != s)
                    strIds += ', ';
                strIds += '\''+s+'\'';
            }
            strIds +=')';
            string q = 'select '+ fieldNames +'  from SVMXC__Service_Contract_Services__c s where s.SVMXC__Service_Contract__c in ' + strIds;
            PartsOrderDetails = database.query(q);
            return PartsOrderDetails;             
        }          
        public  List<SVMXC__Service_Contract_Sites__c> getSVCCoverdLocation(list<string> setID)   
        {
            List<SVMXC__Service_Contract_Sites__c> PartsOrderDetails;
            List<SVMXC__Service_Contract_Sites__c> PartsOrderDetailsArray = new List<SVMXC__Service_Contract_Sites__c> ();
            String fieldNames;
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Sites__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Sites__c.fields.getMap();
                
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);  
            fieldNames +=' , SVMXC__Site__r.Name';
            string strIds = '(';
            for(string s :setID)
            {
                if (setID[0] != s)
                    strIds += ', ';
                strIds += '\''+s+'\'';
            }
            strIds +=')';
            string q = 'select '+ fieldNames +'  from SVMXC__Service_Contract_Sites__c s where s.SVMXC__Service_Contract__c in ' + strIds;
            PartsOrderDetails = database.query(q);
            return PartsOrderDetails;             
        }          
        public  List<SVMXC__Service_Contract_Contacts__c> getSVCEntitledContacts(list<string> setID)   
        {
            List<SVMXC__Service_Contract_Contacts__c> PartsOrderDetails;
            List<SVMXC__Service_Contract_Contacts__c> PartsOrderDetailsArray = new List<SVMXC__Service_Contract_Contacts__c> ();
            String fieldNames;
            Schema.DescribeSObjectResult dsoResult = SVMXC__Service_Contract_Contacts__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Contract_Contacts__c.fields.getMap();
                
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);  
            fieldNames +=' , SVMXC__Contact__r.Name';
            string strIds = '(';
            for(string s :setID)
            {
                if (setID[0] != s)
                    strIds += ', ';
                strIds += '\''+s+'\'';
            }
            strIds +=')';
            string q = 'select '+ fieldNames +'  from SVMXC__Service_Contract_Contacts__c s where s.SVMXC__Service_Contract__c in ' + strIds;
            PartsOrderDetails = database.query(q);
            return PartsOrderDetails;             
        }                 
       
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
       
       
//Getter Setter for report generation as PDF , DOC , XLS
       
//Getter Setter for Tags
    public String getREPTAG001(){ return svmxTagList.containsKey('REPTAG001')?svmxTagList.get('REPTAG001') : '';}
    public String getREPTAG002(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG002') : '';}
    public String getREPTAG003(){ return svmxTagList.containsKey('REPTAG003')?svmxTagList.get('REPTAG003') : '';}
    public String getREPTAG004(){ return svmxTagList.containsKey('REPTAG004')?svmxTagList.get('REPTAG004') : '';}
    public String getREPTAG005(){ return svmxTagList.containsKey('REPTAG005')?svmxTagList.get('REPTAG005') : '';}

public class Wraper 
{
    public string StartDt;
    public string getStartDt() {return this.StartDt;}
    public string EndDt;
    public string getEndDt() {return this.EndDt;}
    public string RenewDt;
    public string getRenewDt() {return this.RenewDt;}
    public double RenNum;
    public double getRenNum() {return this.RenNum;}
    public SVMXC__Service_Contract__c sObj;
    public SVMXC__Service_Contract__c getsObj(){return this.sObj;}
    public list<SVMXC__Service_Contract_Products__c> SVCProductDetails;
        public list<SVMXC__Service_Contract_Products__c> getSVCProductDetails(){return this.SVCProductDetails;}
    public list<SVMXC__Service_Contract_Services__c> SVCIncludedServices;
        public list<SVMXC__Service_Contract_Services__c> getSVCIncludedServices(){return this.SVCIncludedServices;}
    public list<SVMXC__Service_Contract_Sites__c> SVCCoverdLocation;
        public list<SVMXC__Service_Contract_Sites__c> getSVCCoverdLocation(){return this.SVCCoverdLocation;}
    public list<SVMXC__Service_Contract_Contacts__c> SVCEntitledContacts;
        public list<SVMXC__Service_Contract_Contacts__c> getSVCEntitledContacts(){return this.SVCEntitledContacts;}
    
    public Wraper(SVMXC__Service_Contract__c b , list<SVMXC__Service_Contract_Products__c> lstPD, list<SVMXC__Service_Contract_Services__c> lstIS, list<SVMXC__Service_Contract_Sites__c> lstCL, list<SVMXC__Service_Contract_Contacts__c> lstEC)
    {
        sObj = b;
        SVCProductDetails = lstPD;
        SVCIncludedServices = lstIS;
        SVCCoverdLocation = lstCL;
        SVCEntitledContacts = lstEC;
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