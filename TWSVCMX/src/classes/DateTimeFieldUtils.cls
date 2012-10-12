public with sharing class DateTimeFieldUtils {
	public string ObjId= System.currentPageReference().getParameters().get('ObjId');
    public string ObjAPIName= System.currentPageReference().getParameters().get('ObjAPIName');
    public string FieldAPIName= System.currentPageReference().getParameters().get('FieldAPIName');
    public string returnUrl='';
    public  Sobject sobj;
    
    public DateTimeFieldUtils (){
        displayImage = true;
    }
    public pageReference updateObject(){
    	try{
    		
    		String SOQL  = 'SELECT Id , '+FieldAPIName+' FROM '+ObjAPIName +' where id  =:ObjId';
            sobj=Database.query(SOQL);
    		
    	}
    	catch(Exception e){}
          
    
        if(sobj!=null){
        	
            datetime dt = datetime.now();
            sobj.put(FieldAPIName,datetime.valueOf(dt)) ;
            update sobj;
            returnUrl = '/'+sobj.id;
        	PageReference pageRef = new PageReference(returnUrl);
            pageRef.setRedirect(true);
            return pageRef;            
           
      }
      else{
      		returnUrl = '/'+ObjId;
        	PageReference pageRef = new PageReference(returnUrl);
            pageRef.setRedirect(true);
            return pageRef;  
      	
      }
   }
    public Boolean displayImage { get; set; }
  
   

}