public class SVMX_VF_ServiceReport1
{ 
        
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
         fieldNames +=' ,   SVMXC__Contact__r.Name ' ;
         fieldNames +=' ,   SVMXC__Service_Group__r.Name ';
         fieldNames +=' ,   SVMXC__Case__r.CaseNumber ' ;
         fieldNames +=' ,   SVMXC__Component__r.SVMXC__Product__r.Name ';
         fieldNames +=' ,   SVMXC__Component__r.SVMXC__Serial_Lot_Number__c ';
         fieldNames +=' ,   SVMXC__Product__r.Name ';
         fieldNames +=' ,   SVMXC__Preferred_Technician__r.Name ';
         fieldNames +=' ,   SVMXC__Group_Member__r.Name ';
         fieldNames +=' ,   Location__r.Name ';                 
        
        
        SOQLHeader = '  SELECT '+fieldNames+' FROM SVMXC__Service_Order__c where Id=\''+sId+'\''; 
        WorkOrder = Database.query(SOQLHeader); System.debug('WorkOrder.Id: '+WorkOrder.Id);
        } catch (Exception e){}
            return WorkOrder;            
    } 
    
    public  List<SVMXC__Service_Order_Line__c> getWorkOrderDetail()   
    {
        List<SVMXC__Service_Order_Line__c> WorkOrderDetail;
        List<SVMXC__Service_Order_Line__c> WorkOrderDetailArray = new List<SVMXC__Service_Order_Line__c> (); 
        
    
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
            SOQLDetail += '  where SVMXC__Service_Order__c =\''+sId+'\'';        
    
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
        return getFormattedDate(WorkOrder.CreatedDate);  
        //return CreatedDate.format(); 
      }
      
       public String getCurrentDate() {
        return getFormattedDate(System.today());        
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
   
   
   public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
   public list<SVMXC__Service_Order__c> WorkOrderList= new list<SVMXC__Service_Order__c>();
   List<Wraper> WOInfoArray = new List<Wraper>();
   public string strDispTyp = System.currentPageReference().getParameters().get('DispTyp');
   
   public SVMX_VF_ServiceReport1(ApexPages.StandardController controller)
    {
        try
        {
            Map<String, SObjectField> fieldMap = Schema.SObjectType.SVMXC__Service_Order__c.fields.getMap();
            String fieldNames = getFieldNamesFromList(getFieldList2(fieldMap,true));
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Company__r.Name';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Phone';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Fax';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Name';
            fieldNames += ', SVMXC__Service_Order__c.SVMXC__Contact__r.Email';
            fieldNames +=' , SVMXC__Component__r.SVMXC__Product__r.Name ';
            fieldNames +=' , SVMXC__Component__r.SVMXC__Serial_Lot_Number__c ';

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
                 string q = 'select '+ fieldNames +'  from SVMXC__Service_Order__c s where s.id in ' + strIds;
                if (mlst.size()>0 && fieldNames <> null && fieldNames.length() > 0 && strIds <> null && strIds.length() > 0)
                    WorkOrderList = database.query(q );
            } 
            else
            {
                if(sId <> null && sId.length() > 0 && fieldNames <> null && fieldNames.length() > 0)
                {
                    string q = 'select '+ fieldNames +'  from SVMXC__Service_Order__c s where s.id = \'' + sId + '\'';
                    WorkOrderList = database.query(q);
                }
            }
        }
        catch(Exception ex)
        {
        } 
    }
    public  List<Wraper> getWorkOrders()
    {
        try
        {
           set<id> setID = new set<id>();
           for(SVMXC__Service_Order__c wo:WorkOrderList)
           {
             setId.add(wo.id);
           }
           List<SVMXC__Service_Order_Line__c> lines = getWorkOrderDetail(setId);
           for(SVMXC__Service_Order__c wo:WorkOrderList)
           {              
                 List<SVMXC__Service_Order_Line__c> lines2 = new List<SVMXC__Service_Order_Line__c>(); 
                for(SVMXC__Service_Order_Line__c o :lines )
                { 
                    if(wo.id == o.SVMXC__Service_Order__c )
                        lines2.add(o);
                }
                //WOInfoArray.add( new Wraper(wo, lines2, COMM_Utils_Reports.getFormattedDate(wo.CreatedDate)));
           }
        }
        catch(Exception ex)
        {
        }
        return WOInfoArray;
    } 
               
    public  List<SVMXC__Service_Order_Line__c> getWorkOrderDetail(set<id> setID)   
    {
        List<SVMXC__Service_Order_Line__c> WorkOrderDetailArray = new List<SVMXC__Service_Order_Line__c> (); 
        try
        {
            WorkOrderDetailArray = [SELECT id, SVMXC__Line_Type__c, SVMXC__Service_Order__c, SVMXC__Activity_Type__c, SVMXC__Expense_Type__c, SVMXC__Product__r.Name, SVMXC__Reference_Information__c, SVMXC__Actual_Quantity2__c, SVMXC__Actual_Price2__c, SVMXC__Total_Line_Price__c, SVMXC__Estimated_Price2__c, SVMXC__Total_Estimated_Price__c FROM SVMXC__Service_Order_Line__c where SVMXC__Service_Order__c in :setId];     
            for(Integer i=0; i<WorkOrderDetailArray.size();i++){
                
                WorkOrderDetailArray[i].SVMXC__Actual_Price2__c = WorkOrderDetailArray[i].SVMXC__Actual_Price2__c.setScale(2)*1.00+0.00;
            }
        } 
        catch (Exception e)
        {
        }
        return WorkOrderDetailArray;            
    }         
    public static List<String> getFieldList2( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields)
    {
        List<String> fieldList = new List<String>();
        try
        {
            //build dynamic list of fieldnames
            for (String fieldKey : fieldMap.keySet()) 
            {
                Schema.SObjectField fsObj = fieldMap.get(fieldKey);
                Schema.DescribeFieldResult f = fsObj.getDescribe();
                String fieldName;
                fieldName = f.getName();
                if (selectAllFields) 
                        fieldList.add(fieldName);         
                else
                {
                    if (f.getName()=='Id' || f.isNameField() || f.isCustom()) 
                    {
                        fieldList.add(fieldName);
                    }
                }
            }
        } 
        catch (Exception e)
        {
        }    
        return fieldList;
    }
    SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
    public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('WORDREP001');
    public String getREPTAG005(){ return svmxTagList.containsKey('REPTAG005')?svmxTagList.get('REPTAG005') : '';}
    public String getREPTAG006(){ return svmxTagList.containsKey('REPTAG006')?svmxTagList.get('REPTAG006') : '';}
    public String getREPTAG007(){ return svmxTagList.containsKey('REPTAG007')?svmxTagList.get('REPTAG007') : '';}
  
    public class Wraper 
    {
        public SVMXC__Service_Order__c sObj;
        public SVMXC__Service_Order__c getsObj(){return this.sObj;}
        public list<SVMXC__Service_Order_Line__c> lstsObj;
        public list<SVMXC__Service_Order_Line__c> getlstsObj(){return this.lstsObj;}
        public string WOCreatedDate;
        public string getWOCreatedDate() {return this.WOCreatedDate;}
        public Wraper(SVMXC__Service_Order__c b , list<SVMXC__Service_Order_Line__c> lstb, string strb)
        {
            sObj = b;
            lstsObj=lstb;
            WOCreatedDate=strb;
        }
    }     
    
    public static testmethod void test()
    {
        list<SVMXC__Service_Order__c> oRSO= new list<SVMXC__Service_Order__c>();
        SVMXC__Service_Order__c o1 = new SVMXC__Service_Order__c();
        //insert o1;
        PageReference pageRef4 = new PageReference('Page.SVMX_VF_ServiceReport1?RecordId='+o1.Id+'&DispTYP=xls');
        Test.setCurrentPage(pageRef4);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(o1);
        SVMX_VF_ServiceReport1 controller2 = new SVMX_VF_ServiceReport1(controller1);
        //controller2.getstrDispTyp();
        controller2.strDispTyp = 'pdf';
        //controller2.getstrDispTyp();
        controller2.getcontype();
        
        //controller2.getREPTAG002();
       
        controller2.svmxTagList.clear();               
        
        SVMX_VF_ServiceReport1.getFieldList(Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap(), true);
        SVMX_VF_ServiceReport1.getFieldList(Schema.SObjectType.SVMXC__Service_Order_Line__c.fields.getMap(), false);
        SVMX_VF_ServiceReport1.Wraper w = new SVMX_VF_ServiceReport1.Wraper( new SVMXC__Service_Order__c(), new list<SVMXC__Service_Order_Line__c>(),'a' ); 
        w.getsObj();
        w.getlstsObj();
        w.getWOCreatedDate();
    }
    public static testmethod void test2()
    {
        string d = string.valueOf(math.random());
        
        list<SVMXC__Service_Order__c> lstRMASO= new list<SVMXC__Service_Order__c>();
        SVMXC__Service_Order__c o1 = new SVMXC__Service_Order__c();
        SVMXC__Service_Order__c o2 = new SVMXC__Service_Order__c();
        lstRMASO.add(o1);
        lstRMASO.add(o2);
        //insert lstRMASO;
        SVMXC__Service_Order_Line__c oL1 = new SVMXC__Service_Order_Line__c( SVMXC__Service_Order__c = o1.Id);
        //insert oL1;
        list<SVMXC__ServiceMax_List__c> lstSL = new list<SVMXC__ServiceMax_List__c>(); 
        SVMXC__ServiceMax_List__c oSL1 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        SVMXC__ServiceMax_List__c oSL2 = new SVMXC__ServiceMax_List__c (SVMXC__Source_Location__c = d, SVMXC__Object_Id__c =o1.Id );
        
        lstSL.add(oSL1);
        lstSL.add(oSL2);
        insert lstSL;
        
        PageReference pageRef = new PageReference('Page.SVMX_VF_ServiceReport1?d='+d+'&DispTYP=doc');
        Test.setCurrentPage(pageRef);
        SVMX_VF_ServiceReport1 controller2 = new SVMX_VF_ServiceReport1(null);
        //controller2.WorkOrder.clear();
        //controller2.WorkOrder.addAll(lstRMASO);
        controller2.getWorkOrders(); controller2.getWorkOrder(); controller2.getrender();
        controller2.getCurrentDate(); controller2.getREPTAG005(); controller2.getREPTAG006(); controller2.getREPTAG007();
        
    }
}