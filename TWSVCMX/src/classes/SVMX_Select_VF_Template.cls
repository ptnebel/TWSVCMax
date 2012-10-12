public class SVMX_Select_VF_Template
{ 
    // Globle Variable Decleration 
    public boolean AttachFile = false; 
    public boolean getAttachFile(){return AttachFile;}
   	public void setAttachFile(boolean c){this.AttachFile = c;} 
    String PageName;
    public String getPageName(){return PageName;}
    public void setPageName(String PageName){this.PageName = PageName;}
        
    string sId = System.currentPageReference().getParameters().get('id');
    public String ObjName = System.currentPageReference().getParameters().get('ObjName');
    public string d = System.currentPageReference().getParameters().get('d');
    public string getd(){return this.d;}
    string strRecordId;
    public boolean isInsert = true;
    public boolean getisInsert() {return this.isInsert;} 
    public string strDispTyp =System.currentPageReference().getParameters().get('DispTyp');
    public string getstrDispTyp(){if(this.strDispTyp == 'pdf') return this.strDispTyp; else return null;}
    public void setstrDispTyp(string s){this.strDispTyp = s; } 
    public string strReportType;
    public string getstrReportType(){return this.strReportType;}
    public string strAction;
    
    SVMXC.COMM_Utils_ManageTags commUtil = new SVMXC.COMM_Utils_ManageTags();
    public Map<String, String> svmxTagList = commUtil.SVMX_getTagList('COMMSELTEMPLATE');
    public static ApexPages.StandardSetController controller2;
    
    public String retURL = System.currentPageReference().getParameters().get('retURL');
    
    public list<SVMXC__ServiceMax_List__c> tlst= new list<SVMXC__ServiceMax_List__c>();
    public list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();

// Constructor call
    
    public SVMX_Select_VF_Template()
    {
        tlst.clear();
        mlst.clear();
        if(sId != null && sId.length() > 0)
            strReportType = 'SingleRecord';
        else
        {
            string d = System.currentPageReference().getParameters().get('d');
            if(d<> null && d.length() > 0 )
               strReportType = 'MultipalRecord';
        }
    }
 // All Getter & Setter Methods....
   public String getSId() {return sId;}
   public List<SelectOption> getList() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('pdf','PDF')); 
        options.add(new SelectOption('xls','XLS')); 
        options.add(new SelectOption('doc','DOC'));
        return options;
    }

  public List<Document> getMMDetail() 
    {
        List<Document> MMDetail;
        List<Document> MMDetailArray = new List<Document> ();  
       
        String fieldNames;
        String SOQLDetail;
        try
        {            
            Schema.DescribeSObjectResult dsoResult = Document.sObjectType.getDescribe();
            Map<String, SObjectField> fieldMap = Schema.SObjectType.Document.fields.getMap();

            //build a list of all fieldnames for the object
            List<String> fieldList = getFieldList(fieldMap,true);      
            fieldNames = getFieldNamesFromList(fieldList);
            system.debug('asdf'+SOQLDetail);
            SOQLDetail = '  SELECT '+ fieldNames +' FROM Document where Description=\''+ObjName+'\'';
        
            MMDetail = Database.query(SOQLDetail);
            system.debug('asdf'+MMDetail);
            if (MMDetail.size() >0 ) 
            {   
                for ( Document MMLines : MMDetail)
                {
                    MMDetailArray.add(MMLines);
                }
            }   
        
        } catch (Exception e){  }
            return MMDetailArray;            
    } 
    public List<SelectOption> getItems() 
    {
        List<Document> MMDetailArray = new List<Document> ();
        MMDetailArray = getMMDetail();
        List<SelectOption> options = new List<SelectOption>();
        try
        {
            if (MMDetailArray.size()>0)
            {
                for (Document mt: MMDetailArray)
                {
                    options.add(new SelectOption(mt.Keywords, mt.Name)); //Keyword field contains the Vf page name
                }
                return options;
            }
        }
        catch(exception ex)
        {}
        return null;
    }
    public static List<String> getFieldList( Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields)
    {
        List<String> fieldList = new List<String>();
        //build dynamic list of fieldnames
        for (String fieldKey : fieldMap.keySet()) 
        {
            Schema.SObjectField fsObj = fieldMap.get(fieldKey);
            Schema.DescribeFieldResult f = fsObj.getDescribe();
            String fieldName;
            fieldName = f.getName();
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
    public PageReference Generate() 
    {
        if(AttachFile)
        {
            list <Attachment> lstAttachment = new list<Attachment>();
            if(strReportType == 'SingleRecord')
            {
                PageReference myPage = new PageReference('/apex/'+ PageName +'?DispTyp='+ strDispTyp +'&RecordId='+ sId);
                myPage.setRedirect(true);
                if ( myPage!= null)
                {
                    Blob pdfBlob = myPage.getContent();
                    Attachment oAttachment = new Attachment(parentId = sId , name='report.'+strDispTyp, body = pdfBlob);
                    lstAttachment.add(oAttachment);
                }
            }
            else
            {
                list<SVMXC__ServiceMax_List__c> mlst= new list<SVMXC__ServiceMax_List__c>();
                mlst = [select SVMXC__Object_Id__c from SVMXC__ServiceMax_List__c where SVMXC__Source_Location__c = :d ];

                for(SVMXC__ServiceMax_List__c o :mlst )
                {
                    PageReference myPage = new PageReference('/apex/'+ PageName +'?DispTyp='+ strDispTyp +'&RecordId='+ o.SVMXC__Object_Id__c);
                    myPage.setRedirect(true);
                    if ( myPage!= null)
                    {
                        Blob pdfBlob = myPage.getContent();
                        Attachment oAttachment = new Attachment(parentId = o.SVMXC__Object_Id__c, name='report.'+strDispTyp, body = pdfBlob);
                        lstAttachment.add(oAttachment);
                    }
                }
            }
            insert lstAttachment;
        }
        return null;
    }
    public PageReference Cancel() 
    {
        PageReference myPage ;
        if(retURL <> null && retURL.length() > 0)
        {
            myPage = new PageReference(retURL);
            return myPage;
        }
        else if(sid <> null && sid.length() > 0)
        {
            myPage = new PageReference('/'+sid);
            return myPage;
        }
        else
        {
            myPage = new PageReference('/home/home.jsp');
            return myPage;
        }
        return null;
    }
//Gettter Setter For Tags
    public String getREPTAG001(){ return svmxTagList.containsKey('REPTAG001')?svmxTagList.get('REPTAG001') : '';}
    public String getREPTAG002(){ return svmxTagList.containsKey('REPTAG002')?svmxTagList.get('REPTAG002') : '';}
    public String getREPTAG003(){ return svmxTagList.containsKey('REPTAG003')?svmxTagList.get('REPTAG003') : '';}
    public String getREPTAG004(){ return svmxTagList.containsKey('REPTAG004')?svmxTagList.get('REPTAG004') : '';}
    public String getREPTAG005(){ return svmxTagList.containsKey('REPTAG005')?svmxTagList.get('REPTAG005') : '';}
    public String getREPTAG006(){ return svmxTagList.containsKey('REPTAG006')?svmxTagList.get('REPTAG006') : '';}
    public String getREPTAG007(){ return svmxTagList.containsKey('REPTAG007')?svmxTagList.get('REPTAG007') : '';}
    public String getREPTAG008(){ return svmxTagList.containsKey('REPTAG008')?svmxTagList.get('REPTAG008') : '';}
}