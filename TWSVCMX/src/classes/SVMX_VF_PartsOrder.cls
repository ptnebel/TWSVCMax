public class SVMX_VF_PartsOrder
{
    public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
    public list<SVMXC__RMA_Shipment_Order__c> lstRMA_Shipment= new list<SVMXC__RMA_Shipment_Order__c>();
    List<Wraper> RMAShipment = new List<Wraper>();
    public string strDispTyp = System.currentPageReference().getParameters().get('DispTyp');
        public string getstrDispTyp(){if(this.strDispTyp == 'pdf') return this.strDispTyp; else return null;}
    public string contype = System.currentPageReference().getParameters().get('DispTyp');
        public string getcontype (){return COMM_Utils_Reports.getcontype(strDispTyp);}
    
    String strRecordId = System.currentPageReference().getParameters().get('RecordId');
    public SVMX_VF_PartsOrder(ApexPages.StandardController controller) 
    {
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__RMA_Shipment_Order__c.fields.getMap();
        String fieldNames = getFieldNamesFromList(getFieldList(fieldMap,true));
        fieldNames +=' , SVMXC__Company__r.Name ';              
        fieldNames +=' , SVMXC__Source_Location__r.Name';
        fieldNames +=' , SVMXC__Destination_Location__r.Name ';
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
             string q = 'select '+ fieldNames +'  from SVMXC__RMA_Shipment_Order__c s where recordType.Name = \'Shipment\' AND s.id in ' + strIds;
            if (mlst.size()>0)
                lstRMA_Shipment = database.query(q);
        } 
        else
        {
            if(strRecordId <> null && strRecordId.length() > 0 )
            {
                string q = 'select '+ fieldNames +'  from SVMXC__RMA_Shipment_Order__c s where s.id = \'' + strRecordId + '\'';
                lstRMA_Shipment = database.query(q);
            }
        } 

    }


   SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils(); 
   SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
   
   public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('PORTDREP001');   
   String sId = System.currentPageReference().getParameters().get('id');    
   private static SVMXC__RMA_Shipment_Order__c RMAShipment;
   //SVMXC__RMA_Shipment_Order__c
   public  list<Wraper> getRMAShipment2()
   {
           list<string> setID = new list<string>();
           for(SVMXC__RMA_Shipment_Order__c wo:lstRMA_Shipment)
           {
             setId.add(wo.id);
           }
           List<SVMXC__RMA_Shipment_Line__c> lines = getPartsOrderDetails(setId);

           for(SVMXC__RMA_Shipment_Order__c wo:lstRMA_Shipment)
           {              
                
                List<SVMXC__RMA_Shipment_Line__c> lines2 = new List<SVMXC__RMA_Shipment_Line__c>(); 
                for(SVMXC__RMA_Shipment_Line__c o :lines )
                { 
                    if(wo.id == o.SVMXC__RMA_Shipment_Order__c )
                        lines2.add(o);
                }
                Wraper WOInfoObj = new Wraper(wo, lines2);
                WOInfoObj.RMADate= getFormattedDate(wo.CreatedDate);
                    RMAShipment.add( WOInfoObj );
           }
                   
            return RMAShipment;    
       }

    public  List<SVMXC__RMA_Shipment_Line__c> getPartsOrderDetails(list<string> setID)   
    {
        List<SVMXC__RMA_Shipment_Line__c> PartsOrderDetails;
        List<SVMXC__RMA_Shipment_Line__c> PartsOrderDetailsArray = new List<SVMXC__RMA_Shipment_Line__c> ();
        String fieldNames;
        Schema.DescribeSObjectResult dsoResult = SVMXC__RMA_Shipment_Line__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__RMA_Shipment_Line__c.fields.getMap();
            
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
        string q = 'select '+ fieldNames +'  from SVMXC__RMA_Shipment_Line__c s where s.SVMXC__RMA_Shipment_Order__c in ' + strIds;
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
            else 
            {
                if (f.getName()=='Id' || f.isNameField() || f.isCustom()) 
                {
                fieldList.add(fieldName);
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
//Getter Setter for Tags
    public String getREPTAG001(){ return svmxTagList.containsKey('REPTAG001')?svmxTagList.get('REPTAG001') : '';}
    public String getREPTAG002(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG002') : '';}
    public String getREPTAG003(){ return svmxTagList.containsKey('REPTAG003')?svmxTagList.get('REPTAG003') : '';}
    public String getREPTAG004(){ return svmxTagList.containsKey('REPTAG004')?svmxTagList.get('REPTAG004') : '';}
    public String getREPTAG005(){ return svmxTagList.containsKey('REPTAG005')?svmxTagList.get('REPTAG005') : '';}
    
    public class Wraper 
    {
        public string RMADate;
        public string getRMADate() {return this.RMADate;}
        public SVMXC__RMA_Shipment_Order__c sObj;
        public SVMXC__RMA_Shipment_Order__c getsObj(){return this.sObj;}
        public list<SVMXC__RMA_Shipment_Line__c> lstsObj;
        public list<SVMXC__RMA_Shipment_Line__c> getlstsObj(){return this.lstsObj;}
        public Wraper(SVMXC__RMA_Shipment_Order__c b , list<SVMXC__RMA_Shipment_Line__c> lstb)
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
/*public class SVMX_VF_PartsOrder
{
    public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
    public list<SVMXC__RMA_Shipment_Order__c> lstRMA_Shipment= new list<SVMXC__RMA_Shipment_Order__c>();
    List<Wraper> RMAShipment = new List<Wraper>();
    public string strDispTyp = System.currentPageReference().getParameters().get('DispTyp');
        public string getstrDispTyp(){if(this.strDispTyp == 'pdf') return this.strDispTyp; else return null;}
    public string contype = System.currentPageReference().getParameters().get('DispTyp');
        public string getcontype (){return COMM_Utils_Reports.getcontype(strDispTyp);}
    
    String strRecordId = System.currentPageReference().getParameters().get('RecordId');
    public SVMX_VF_PartsOrder(ApexPages.StandardController controller) 
    {
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__RMA_Shipment_Order__c.fields.getMap();
        String fieldNames = getFieldNamesFromList(getFieldList(fieldMap,true));
        fieldNames +=' , SVMXC__Company__r.Name ';              
        fieldNames +=' , SVMXC__Source_Location__r.Name';
        fieldNames +=' , SVMXC__Destination_Location__r.Name ';
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
             string q = 'select '+ fieldNames +'  from SVMXC__RMA_Shipment_Order__c s where recordType.Name = \'Shipment\' AND s.id in ' + strIds;
            if (mlst.size()>0)
                lstRMA_Shipment = database.query(q);
        } 
        else
        {
            if(strRecordId <> null && strRecordId.length() > 0 )
            {
                string q = 'select '+ fieldNames +'  from SVMXC__RMA_Shipment_Order__c s where s.id = \'' + strRecordId + '\'';
                lstRMA_Shipment = database.query(q);
            }
        } 

    }


   SVMXC.COMM_Utils utils = new SVMXC.COMM_Utils(); 
   SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
   
   public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('PORDGENREP');   
   String sId = System.currentPageReference().getParameters().get('id');    
   private static SVMXC__RMA_Shipment_Order__c RMAShipment;
   //SVMXC__RMA_Shipment_Order__c
   public  list<Wraper> getRMAShipment2()
   {
           list<string> setID = new list<string>();
           for(SVMXC__RMA_Shipment_Order__c wo:lstRMA_Shipment)
           {
             setId.add(wo.id);
           }
           List<SVMXC__RMA_Shipment_Line__c> lines = getPartsOrderDetails(setId);

           for(SVMXC__RMA_Shipment_Order__c wo:lstRMA_Shipment)
           {              
                
                List<SVMXC__RMA_Shipment_Line__c> lines2 = new List<SVMXC__RMA_Shipment_Line__c>(); 
                for(SVMXC__RMA_Shipment_Line__c o :lines )
                { 
                    if(wo.id == o.SVMXC__RMA_Shipment_Order__c )
                        lines2.add(o);
                }
                Wraper WOInfoObj = new Wraper(wo, lines2);
                WOInfoObj.RMADate= getFormattedDate(wo.CreatedDate);
                    RMAShipment.add( WOInfoObj );
           }
                   
            return RMAShipment;    
       }

	public  List<SVMXC__RMA_Shipment_Line__c> getPartsOrderDetails(list<string> setID)   
    {
        List<SVMXC__RMA_Shipment_Line__c> PartsOrderDetails;
        List<SVMXC__RMA_Shipment_Line__c> PartsOrderDetailsArray = new List<SVMXC__RMA_Shipment_Line__c> ();
        String fieldNames;
        Schema.DescribeSObjectResult dsoResult = SVMXC__RMA_Shipment_Line__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__RMA_Shipment_Line__c.fields.getMap();
            
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
        string q = 'select '+ fieldNames +'  from SVMXC__RMA_Shipment_Line__c s where s.SVMXC__RMA_Shipment_Order__c in ' + strIds;
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
	        else 
	        {
	            if (f.getName()=='Id' || f.isNameField() || f.isCustom()) 
	            {
                fieldList.add(fieldName);
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
//Getter Setter for Tags
    public String getREPTAG001(){ return svmxTagList.containsKey('REPTAG001')?svmxTagList.get('REPTAG001') : '';}
    public String getREPTAG002(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG002') : '';}
    public String getREPTAG003(){ return svmxTagList.containsKey('REPTAG003')?svmxTagList.get('REPTAG003') : '';}
    public String getREPTAG004(){ return svmxTagList.containsKey('REPTAG004')?svmxTagList.get('REPTAG004') : '';}
    public String getREPTAG005(){ return svmxTagList.containsKey('REPTAG005')?svmxTagList.get('REPTAG005') : '';}

	public class Wraper 
	{
	    public string RMADate;
	    public string getRMADate() {return this.RMADate;}
	    public SVMXC__RMA_Shipment_Order__c sObj;
	    public SVMXC__RMA_Shipment_Order__c getsObj(){return this.sObj;}
	    public list<SVMXC__RMA_Shipment_Line__c> lstsObj;
	    public list<SVMXC__RMA_Shipment_Line__c> getlstsObj(){return this.lstsObj;}
	    public Wraper(SVMXC__RMA_Shipment_Order__c b , list<SVMXC__RMA_Shipment_Line__c> lstb)
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
}*/