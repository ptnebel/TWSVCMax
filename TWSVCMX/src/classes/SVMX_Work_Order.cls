public class SVMX_Work_Order
{
    SVMXC__Service_Order__c SVMX_WorkOrder;
     
    public SVMX_Work_Order(SVMXC__Service_Order__c svo)
    {
    	SVMX_WorkOrder = new SVMXC__Service_Order__c();
        SVMX_WorkOrder = svo;
    }
    
    public SVMX_Work_Order()
    {
        SVMX_WorkOrder = new SVMXC__Service_Order__c();
    }
    
    public SVMXC__Service_Order__c getSVMX_WorkOrder()
    {
    	
        return SVMX_WorkOrder;
    }
    
    public void setSVMX_WorkOrder(SVMXC__Service_Order__c svo)
    {
        SVMX_WorkOrder = svo;
    }
    
    public String getWOCreatedDate()
    {
        return getFormattedDate(SVMX_WorkOrder.CreatedDate);
    }
    
       //Method to convert DateTime into String Format     
    public String getFormattedDate(DateTime dat) 
    {
             String blank='';
             if (dat == null)
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
    
      //Method to convert Date into String Format     
    public String getFormattedDate(Date dat) 
    {
             String blank='';
             if (dat == null)
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