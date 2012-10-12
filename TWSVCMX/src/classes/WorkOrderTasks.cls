public with sharing class WorkOrderTasks {
//1. Update Tasks
    public static void CreateTasks(SVMXC__Service_Order__c[] orders){
        System.debug('Triggered CreateTasks');
        // Get matching Task Templates
        Map<id, SVMXC__Service_Order__c> prodMap = new Map<id,SVMXC__Service_Order__c>();
        for(SVMXC__Service_Order__c i: orders){
            prodMap.put(i.SVMXC__Product__c, i);
        } 
         
        List<WO_Task_Template__c> TaskList = new List<WO_Task_Template__c>();
        for(Product2 prod: [select id, (select id, Associated_Part__c, Matching_Product__c, Task_Order__c, Task_Description__c from WO_Task_Templates_MatchingProduct__r ORDER BY Task_Order__c) from Product2 where Id in: prodMap.keySet()]){         
            for(WO_Task_Template__c temp: prod.WO_Task_Templates_MatchingProduct__r){
                Boolean InTaskList = false;
                for(WO_Task_Template__c task: TaskList){
                    if(temp.id==task.id){InTaskList=true;} 
                } 
                if(InTaskList==false){
                    TaskList.add(temp);
                }
            }  
        }
        System.debug('TaskList size: '+TaskList.size());
        
        // Get order and tasks
        List<Work_Order_Task__c> wotasksList = new List<Work_Order_Task__c>();
        Map<id, SVMXC__Service_Order__c> orderMap = new Map<id,SVMXC__Service_Order__c>();
        for(SVMXC__Service_Order__c i: orders){
            orderMap.put(i.id, i);
        } 
        
        for(SVMXC__Service_Order__c ord: [select id, SVMXC__Company__r.Id, SVMXC__Order_Status__c, SVMXC__Component__r.Id, SVMXC__Product__c, SVMXC__Product__r.id, (select id, Task_Description__c, Task_Order__c, Tech_Description__c, Associated_Part__c, Work_Order__r.SVMXC__Product__c from Work_Order_Tasks_WO__r ORDER BY Task_Order__c) from SVMXC__Service_Order__c where Id in: orderMap.keySet()]){
            List<Work_Order_Task__c> wotasks = new List<Work_Order_Task__c>();
            for(Work_Order_Task__c wt: ord.Work_Order_Tasks_WO__r){
                wotasks.add(wt);
            }
            
            for(WO_Task_Template__c t:TaskList){
                Boolean AlreadyTasked = false;
                for(Work_Order_Task__c ta: wotasks){
                    if(ta.Task_Description__c==t.Task_Description__c && ta.Work_Order__r.SVMXC__Product__c==t.Matching_Product__c){
                        AlreadyTasked = true;
                    }
                }
                if(AlreadyTasked==false && ord.SVMXC__Product__c==t.Matching_Product__c){
                    Work_Order_Task__c newtask = new Work_Order_Task__c();
                    newtask.Associated_Part__c = t.Associated_Part__c;
                    newtask.Work_Order__c = ord.id;
                    newtask.Task_Order__c = t.Task_Order__c;
                    newtask.Task_Description__c = t.Task_Description__c;
                    wotasksList.add(newtask);
                }
            }
        }
        if(wotasksList.size()>0) insert wotasksList; 
    }
     
    String workorderId = System.currentPageReference().getParameters().get('id');
    String workorderName = System.currentPageReference().getParameters().get('name');   
    public String getWorkOrderName(){ 
        return workorderName; 
    }
    
    List<Work_Order_Task__c> Tasks = new List<Work_Order_Task__c>();
    public List<Work_Order_Task__c> getWOTasks() {
        ViewWOTasks();
        return Tasks; 
    }   
    public void ViewWOTasks() {   
        Schema.DescribeSObjectResult dsoResult = Work_Order_Task__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.Work_Order_Task__c.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
        System.debug('workorderId: '+workorderId);
        String SOQLDetail = ' SELECT '+fieldNames+' FROM Work_Order_Task__c where Work_Order__c=\''+workorderId+'\' ORDER BY Task_Order__c limit 200';        
        Tasks = Database.query(SOQLDetail);  
    } 
    
    public PageReference QuickSaveTasks() { 
        update Tasks;
        return null;
    }
    
    public PageReference SaveTasks(){
        update Tasks;
        PageReference page = new PageReference('/'+workorderId);
        return page;
    }
    
    public PageReference CancelTasks(){
        PageReference page = new PageReference('/'+workorderId);
        return page;
    }

//2. Create Child WO
//======================================= Constructor =============================================//
    
    String wotaskId = System.currentPageReference().getParameters().get('id');
    String wotaskName = System.currentPageReference().getParameters().get('name');  
    public String getWorkTaskName(){ return wotaskName;}
    public String relatingtaskId{get; set{relatingtaskId = value;}}
    public String relatingtaskName{get; set{relatingtaskName = value;}}
    public PageReference CreateFollowupWO(){
        PageReference page = new PageReference('/apex/Create_Child_WO?id='+relatingtaskId+'&name='+relatingtaskName);       
        page.setRedirect(true);
        return page;    
    }
    
    Work_Order_Task__c task = new Work_Order_Task__c();    
    public Work_Order_Task__c getTask(){
        ViewTask(); return task;
    }
    public void ViewTask() {   
        Schema.DescribeSObjectResult dsoResult = Work_Order_Task__c.sObjectType.getDescribe();
        Map<String, SObjectField> fieldMap = Schema.SObjectType.Work_Order_Task__c.fields.getMap();
        List<String> fieldList = getFieldList(fieldMap,true);      
        String fieldNames = getFieldNamesFromList(fieldList);
        fieldNames += ', Work_Order__r.SVMXC__Street__c';
        fieldNames += ', Work_Order__r.SVMXC__City__c';
        fieldNames += ', Work_Order__r.SVMXC__State__c';
        fieldNames += ', Work_Order__r.SVMXC__Country__c';
        fieldNames += ', Work_Order__r.SVMXC__Zip__c';
        fieldNames += ', Work_Order__r.Name';
        fieldNames += ', Work_Order__r.SVMXC__Company__c';
        System.debug('workorderId: '+workorderId);      
        String SOQLDetail = ' SELECT '+fieldNames+' FROM Work_Order_Task__c where Id=\''+wotaskId+'\' limit 1';        
        task = Database.query(SOQLDetail);  
        System.debug('task work order street:'+task.Work_Order__r.SVMXC__Street__c);
    }       

    public SVMXC__Service_Order__c WOHeader = new SVMXC__Service_Order__c();    
    public SVMXC__Service_Order__c getWOrderHeader() {
        CreateChildWO();    
        return WOHeader;            
    }      
    public void CreateChildWO(){  
        /*error checking could go here*/               
        //Set Required: 
            if(WOHeader.OwnerId == null) WOHeader.OwnerId = UserInfo.getUserId();
            if(WOHeader.SVMXC__Product__c == null) WOHeader.SVMXC__Product__c = task.Associated_Part__c;
            if(WOHeader.SVMXC__Problem_Description__c == null) WOHeader.SVMXC__Problem_Description__c = task.Tech_Description__c;
            
            if(WOHeader.SVMXC__Company__c == null) WOHeader.SVMXC__Company__c = task.Work_Order__r.SVMXC__Company__c;
             
        //Set Default Picklist Value
            if(WOHeader.SVMXC__Order_Status__c == null) WOHeader.SVMXC__Order_Status__c = 'Open';
            if(WOHeader.SVMXC__Priority__c == null) WOHeader.SVMXC__Priority__c = 'Medium'; 
        
        //Set Address
            if(WOHeader.SVMXC__Street__c == null) WOHeader.SVMXC__Street__c = task.Work_Order__r.SVMXC__Street__c;
            if(WOHeader.SVMXC__City__c == null) WOHeader.SVMXC__City__c = task.Work_Order__r.SVMXC__City__c;
            if(WOHeader.SVMXC__State__c == null) WOHeader.SVMXC__State__c = task.Work_Order__r.SVMXC__State__c;
            if(WOHeader.SVMXC__Country__c == null) WOHeader.SVMXC__Country__c = task.Work_Order__r.SVMXC__Country__c;
            if(WOHeader.SVMXC__Zip__c == null) WOHeader.SVMXC__Zip__c = task.Work_Order__r.SVMXC__Zip__c;           
    }
    
    public PageReference SaveChildWO(){
        insert WOHeader;
        PageReference page = new PageReference('/'+WOHeader.Id);
        return page;
    }
    
    public PageReference CancelChildWO(){
        PageReference page = new PageReference('/'+workorderId);
        return page;
    }
    
    
    //Utility Methods used in generating Dynamic SOQL    
    public static List<String> getFieldList( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields){
        List<String> fieldList = new List<String>();        
        //build dynamic list of fieldnames
        for (String fieldKey : fieldMap.keySet()){
            Schema.SObjectField fsObj = fieldMap.get(fieldKey);
            Schema.DescribeFieldResult f = fsObj.getDescribe();
            String fieldName = f.getName();            
            if (selectAllFields){ fieldList.add(fieldName); 
            } else { if (f.getName()=='Id' || f.isNameField() || f.isCustom()) { fieldList.add(fieldName);}
            }
        }        
        return fieldList;
    }
    public static String getFieldNamesFromList(List<String> fieldList){
        String fieldNames = '';
        for (String field : fieldList) {
            if (fieldNames.length()>0) {
                fieldNames += ',';
            }
            fieldNames += field;
        }        
        return fieldNames;
    }
    
// Tasks Completed    
    public static void TaskCompleted(Work_Order_Task__c[] tasks){  
        Map<id, Work_Order_Task__c> wodetailMap = new Map<id, Work_Order_Task__c>();
        for(Work_Order_Task__c i: tasks){
            wodetailMap.put(i.Work_Order__c, i);
        }
        
        List<SVMXC__Service_Order_Line__c> WODetailList = [select id, SVMXC__Product__c from SVMXC__Service_Order_Line__c where SVMXC__Service_Order__c in: wodetailMap.keySet()];                      
        System.debug('WODetailList size:'+WODetailList.size()); 
            
        Map<id, Work_Order_Task__c> tasksMap = new Map<id,Work_Order_Task__c>();
        for(Work_Order_Task__c i: tasks){
            tasksMap.put(i.id, i);
        }
        
        List<SVMXC__Service_Order_Line__c> newWOLines = new List<SVMXC__Service_Order_Line__c>();   
        for(Work_Order_Task__c wotask: [select id, Associated_Part__c, Work_Order__c, Task_Completed__c from Work_Order_Task__c where Id in: tasksMap.keySet()]){           
            //Handle Completed Tasks
            if(wotask.Task_Completed__c==true){
                Boolean alreadyAdded = false;
                for(SVMXC__Service_Order_Line__c l: WODetailList){
                    if(l.SVMXC__Product__c == wotask.Associated_Part__c){alreadyAdded=true;}                    
                }
                if(alreadyAdded==false){
                    SVMXC__Service_Order_Line__c newWOLine = new SVMXC__Service_Order_Line__c();
                    newWOLine.SVMXC__Product__c = wotask.Associated_Part__c;
                    newWOLine.SVMXC__Service_Order__c = wotask.Work_Order__c;
                    newWOLine.SVMXC__Line_Type__c = 'Part';
                    newWOLines.add(newWOLine);
                }
            }
        }
        if(newWOLines.size()>0) insert newWOLines;
    }
    
    
    // Test Methods 
    static testmethod void test1(){
        //Create Products   
        Product2 prod1 = new Product2(Name='product name'); 
        Product2 prod2 = new Product2(Name='product name'); 
        insert prod1; insert prod2;
        
        //Create WO Order Task Template
        WO_Task_Template__c template1 = new WO_Task_Template__c();
        template1.Matching_Product__c = prod1.id;
        template1.Task_Description__c = 'Description';
        template1.Associated_Part__c = prod2.id;
        insert template1;
        
        //Create Work Order with product
        SVMXC__Service_Order__c wo = new SVMXC__Service_Order__c(Name ='WO1');      
        wo.SVMXC__Product__c = prod1.id;      
        insert wo;  
        
        //Create Task
        Work_Order_Task__c task1 = new Work_Order_Task__c();
        task1.Work_Order__c = wo.id;
        task1.Associated_Part__c = prod2.id; insert task1;
        task1.Task_Completed__c = true; update task1;
       
        Test.startTest(); 
        //Test coverage for the MassUpdateWOTasks visualforce page       
        PageReference pageRef = Page.MassUpdateWOTasks;
        pageRef.getParameters().put('id',wo.Id);
        Test.setCurrentPageReference(pageRef);   
        ApexPages.StandardController mc = new Apexpages.Standardcontroller(wo);
        WorkOrderTasks myPageCon1 = new WorkOrderTasks();   
        myPageCon1.getWorkOrderName(); myPageCon1.getWOTasks();    
        myPageCon1.QuickSaveTasks();
        myPageCon1.SaveTasks();
        myPageCon1.CancelTasks();    
        
        //Test coverage for the CreateChildWO visualforce page       
        PageReference pageRef1 = Page.Create_Child_WO;
        pageRef1.getParameters().put('id',task1.Id);
        pageRef1.getParameters().put('name',task1.Name);
        Test.setCurrentPageReference(pageRef1);
        
        ApexPages.StandardController mc1 = new Apexpages.Standardcontroller(task1);
        WorkOrderTasks myPageCon2 = new WorkOrderTasks();
        myPageCon2.getWOrderHeader(); myPageCon2.getWorkTaskName(); myPageCon2.getTask();
        myPageCon2.SaveChildWO();
        myPageCon2.CancelChildWO();
        myPageCon2.CreateFollowupWO();
        
        Test.stopTest(); 
    }
        
}