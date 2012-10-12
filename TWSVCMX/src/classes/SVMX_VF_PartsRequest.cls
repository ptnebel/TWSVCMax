public with sharing class SVMX_VF_PartsRequest {
	public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
    public list<SVMXC__Parts_Request__c> lstParts_Reqest= new list<SVMXC__Parts_Request__c>();
    List<Wraper> PARTSRequest = new List<Wraper>();
    public string strDispTyp = System.currentPageReference().getParameters().get('DispTyp');
    public string getstrDispTyp(){if(this.strDispTyp == 'pdf') return this.strDispTyp; else return null;}
    public string contype = System.currentPageReference().getParameters().get('DispTyp');
    public string getcontype (){return COMM_Utils_Reports.getcontype(strDispTyp);}
    
    String strRecordId = System.currentPageReference().getParameters().get('RecordId');
    public SVMX_VF_PartsRequest(ApexPages.StandardController controller) 
    {
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Parts_Request__c.fields.getMap();
        String fieldNames = getFieldNamesFromList(getFieldList(fieldMap,true));
        fieldNames +=' , SVMXC__Company__r.Name ';              
        fieldNames +=' , SVMXC__Requested_From__r.Name';
        fieldNames +=' , SVMXC__Required_At_Location__r.Name ';
        string d = System.currentPageReference().getParameters().get('d');
        if(d<> null && d.length() > 0 )
        {
            mlst = [select SVMXC__Object_Id__c from SVMXC__ServiceMax_List__c where SVMXC__Source_Location__c = :d ];
            list<string> s= new list<string>();
            system.debug('asdf'+mlst);
            string strIds = '(';
            for(SVMXC__ServiceMax_List__c o :mlst )
            {
                s.add(o.ID);
                system.debug('asdf'+mlst[0].Id+'='+o.ID);
                if (mlst[0].Id != o.ID)
                    strIds += ', ';
                strIds += '\''+o.SVMXC__Object_Id__c +'\'';
            }
            strIds +=')';
             string q = 'select '+ fieldNames +'  from SVMXC__Parts_Request__c s where   s.id in ' + strIds;
            if (mlst.size()>0)
                lstParts_Reqest = database.query(q);
        } 
        else
        {
            if(strRecordId <> null && strRecordId.length() > 0 )
            {
                string q = 'select '+ fieldNames +'  from SVMXC__Parts_Request__c s where s.id = \'' + strRecordId + '\'';
                lstParts_Reqest = database.query(q);
            }
        } 

    }


   SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils(); 
   SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
   public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('PREQREP001');   
   
    

    String cId = System.currentPageReference().getParameters().get('cid');

    String sId = System.currentPageReference().getParameters().get('id');    
       private static SVMXC__Parts_Request__c PARTSRequest;
       //SVMXC__Parts_Request__c
       public  list<Wraper> getPARTSRequest2()
       {
    
           list<string> setID = new list<string>();
           for(SVMXC__Parts_Request__c wo:lstParts_Reqest)
           {
             setId.add(wo.id);
           }
           List<SVMXC__Parts_Request_Line__c> lines = getPARTSRequestDetails(setId);

           for(SVMXC__Parts_Request__c wo:lstParts_Reqest)
           {              
                
                List<SVMXC__Parts_Request_Line__c> lines2 = new List<SVMXC__Parts_Request_Line__c>(); 
                for(SVMXC__Parts_Request_Line__c o :lines )
                { 
                    if(wo.id == o.SVMXC__Parts_Request__c )
                        lines2.add(o);
                }
                Wraper WOInfoObj = new Wraper(wo, lines2);
                WOInfoObj.RMADate= getFormattedDate(wo.CreatedDate);
                
                    PARTSRequest.add( WOInfoObj );
           }
                   
            return PARTSRequest;    
       }
         
       public  List<SVMXC__Parts_Request_Line__c> getPARTSRequestDetails(list<string> setID)   
        {
        List<SVMXC__Parts_Request_Line__c> PARTSRequestDetails;
        List<SVMXC__Parts_Request_Line__c> PARTSRequestDetailsArray = new List<SVMXC__Parts_Request_Line__c> ();
        
           
            String fieldNames;
            Schema.DescribeSObjectResult dsoResult = SVMXC__Parts_Request_Line__c.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Parts_Request_Line__c.fields.getMap();
                
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
             string q = 'select '+ fieldNames +'  from SVMXC__Parts_Request_Line__c  where SVMXC__Parts_Request__c in ' + strIds;
               System.debug('asdf'+q);
                PARTSRequestDetails = database.query(q);
                
                return PARTSRequestDetails;              
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
//Getter Setter for Tags
    public String getREPTAG001(){ return svmxTagList.containsKey('REPTAG001')?svmxTagList.get('REPTAG001') : '';}
    public String getREPTAG002(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG002') : '';}
   
	
public class Wraper 
{
    public string RMADate;
    public string getRMADate() {return this.RMADate;}
    public SVMXC__Parts_Request__c sObj;
    public SVMXC__Parts_Request__c getsObj(){return this.sObj;}
    public list<SVMXC__Parts_Request_Line__c> lstsObj;
    public list<SVMXC__Parts_Request_Line__c> getlstsObj(){return this.lstsObj;}
    public Wraper(SVMXC__Parts_Request__c b , list<SVMXC__Parts_Request_Line__c> lstb)
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