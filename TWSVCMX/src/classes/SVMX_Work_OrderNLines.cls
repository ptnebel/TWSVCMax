public class SVMX_Work_OrderNLines
{
   
    public SVMX_Work_Order   				    WOHeader;
    private  List<SVMXC__Service_Order_Line__c> WOLines;
  
    public SVMX_Work_OrderNLines()
    	{
    		WOHeader = new SVMX_Work_Order();
    	}
    	
    public SVMX_Work_OrderNLines   Assign(SVMXC__Service_Order__c WOHDR, List<SVMXC__Service_Order_Line__c>  WOL)
        {
            SVMX_Work_OrderNLines obj = new SVMX_Work_OrderNLines();
            obj.WOHeader.setSVMX_WorkOrder(WOHDR);
            obj.WOLines = WOL;
            return obj;
        }
        
  /* public String getWOCDate()
   		{
   		return 	WOHeader.getWOCreatedDate();
   		}
   		*/
   		
   public List<SVMXC__Service_Order_Line__c> getLines()
        {
        return  WOLines;
        }
        
   public SVMX_Work_Order getSVOHeader()
        {
        return  WOHeader;
        }
}